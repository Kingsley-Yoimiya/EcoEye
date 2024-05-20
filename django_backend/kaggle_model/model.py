import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow.keras.models import load_model
from sklearn.preprocessing import StandardScaler
from sklearn.feature_selection import SelectKBest, f_regression
import keras

# 查看版本
print("TensorFlow version:", tf.__version__)
print("Keras version:", keras.__version__)

# 自定义 R2Loss
class R2Loss(tf.keras.losses.Loss):
    def __init__(self, use_mask=False, name="r2_loss"):
        super().__init__(name=name)
        self.use_mask = use_mask

    def call(self, y_true, y_pred):
        if self.use_mask:
            mask = tf.not_equal(y_true, -1)
            y_true = tf.where(mask, y_true, 0.0)
            y_pred = tf.where(mask, y_pred, 0.0)
        SS_res = tf.reduce_sum(tf.square(y_true - y_pred), axis=0)  # (B, C) -> (C,)
        SS_tot = tf.reduce_sum(tf.square(y_true - tf.reduce_mean(y_true, axis=0)), axis=0)  # (B, C) -> (C,)
        r2_loss = SS_res / (SS_tot + 1e-6)  # (C,)
        return tf.reduce_mean(r2_loss)  # ()

# 自定义 R2Metric
class R2Metric(tf.keras.metrics.Metric):
    def __init__(self, name="r2", **kwargs):
        super(R2Metric, self).__init__(name=name, **kwargs)
        self.SS_res = self.add_weight(name='SS_res', shape=(6,), initializer='zeros')
        self.SS_tot = self.add_weight(name='SS_tot', shape=(6,), initializer='zeros')
        self.num_samples = self.add_weight(name='num_samples', initializer='zeros')

    def update_state(self, y_true, y_pred, sample_weight=None):
        SS_res = tf.reduce_sum(tf.square(y_true - y_pred), axis=0)
        SS_tot = tf.reduce_sum(tf.square(y_true - tf.reduce_mean(y_true, axis=0)), axis=0)
        self.SS_res.assign_add(SS_res)
        self.SS_tot.assign_add(SS_tot)
        self.num_samples.assign_add(tf.cast(tf.shape(y_true)[0], "float32"))

    def result(self):
        r2 = 1 - self.SS_res / (self.SS_tot + 1e-6)
        return tf.reduce_mean(r2)

    def reset_states(self):
        self.SS_res.assign(0)
        self.SS_tot.assign(0)
        self.num_samples.assign(0)

# 自定义 TransformerEncoderBlock
class TransformerEncoderBlock(tf.keras.layers.Layer):
    def __init__(self, embed_dim, num_heads, ff_dim, rate=0.1, **kwargs):
        super(TransformerEncoderBlock, self).__init__(**kwargs)
        self.att = tf.keras.layers.MultiHeadAttention(num_heads=num_heads, key_dim=embed_dim)
        self.ffn = tf.keras.Sequential(
            [tf.keras.layers.Dense(ff_dim, activation="relu"), tf.keras.layers.Dense(embed_dim),]
        )
        self.layernorm1 = tf.keras.layers.LayerNormalization(epsilon=1e-6)
        self.layernorm2 = tf.keras.layers.LayerNormalization(epsilon=1e-6)
        self.dropout1 = tf.keras.layers.Dropout(rate)
        self.dropout2 = tf.keras.layers.Dropout(rate)

    def call(self, inputs, training=False):
        attn_output = self.att(inputs, inputs)
        attn_output = self.dropout1(attn_output, training=training)
        out1 = self.layernorm1(inputs + attn_output)
        ffn_output = self.ffn(out1)
        ffn_output = self.dropout2(ffn_output, training=training)
        return self.layernorm2(out1 + ffn_output)

# 配置类
class CFG:
    verbose = 1  # Verbosity
    seed = 42  # Random seed
    preset = "efficientnetv2_b2_imagenet"  # Name of pretrained classifier
    image_size = [224, 224]  # Input image size
    epochs = 10  # Training epochs
    batch_size = 96  # Batch size
    lr_mode = "step"  # LR scheduler mode from one of "cos", "step", "exp"
    drop_remainder = True  # Drop incomplete batches
    num_classes = 6  # Number of classes in the dataset
    num_folds = 5  # Number of folds to split the dataset
    fold = 0  # Which fold to set as validation data
    class_names = ['X4_mean', 'X11_mean', 'X18_mean',
                   'X26_mean', 'X50_mean', 'X3112_mean']
    aux_class_names = list(map(lambda x: x.replace("mean", "sd"), class_names))
    num_classes = len(class_names)
    aux_num_classes = len(aux_class_names)

# 加载训练好的模型
model = load_model("best_model.keras", custom_objects={
    "R2Loss": R2Loss,
    "R2Metric": R2Metric,
    "TransformerEncoderBlock": TransformerEncoderBlock
})

# 加载训练数据以计算辅助参数的平均值
df = pd.read_csv('train.csv')
df = df[(df['X4_mean'] > 0) &
        (df['X11_mean'] < 200) &
        (df['X18_mean'] < 70) &
        (df['X50_mean'] < 200) &
        (df['X26_mean'] < 25000) &
        (df['X3112_mean'] < 300000)]

print("GET DATA")

# 定义特征列
FEATURE_COLS = df.columns[1:-1].tolist()

# 使用 SelectKBest 选择最佳特征
all_selected_features = set()
for target_col in CFG.class_names:
    selector = SelectKBest(score_func=f_regression, k=10)
    selector.fit(df[FEATURE_COLS], df[target_col])
    selected_indices = selector.get_support(indices=True)
    selected_features_for_target = [FEATURE_COLS[i] for i in selected_indices]
    all_selected_features.update(selected_features_for_target)

# 最终选择的特征
top_features = list(all_selected_features)
if 'id' in top_features:
    top_features.remove('id')

# 计算辅助参数的平均值
mean_features = df[top_features].mean()

# 对特征进行标准化
scaler = StandardScaler()
scaler.fit(df[top_features].values)

# 预处理测试图片的函数
def preprocess_image(image_path, target_size):
    file_bytes = tf.io.read_file(image_path)
    image = tf.io.decode_jpeg(file_bytes)
    image = tf.image.resize(image, size=target_size, method="area")
    image = tf.cast(image, tf.float32)
    image /= 255.0
    image = tf.reshape(image, [*target_size, 3])
    return image

# 用训练数据的均值填充辅助参数并标准化
test_features = mean_features.values.reshape(1, -1)
test_features = scaler.transform(test_features)

# 预测函数
def predict(image_path):
    # 预处理图片
    test_image = preprocess_image(image_path, CFG.image_size)

    # 构建预测输入
    test_input = {"images": np.expand_dims(test_image, axis=0), "features": test_features}

    # 进行预测
    pred = model.predict(test_input)["head"]
    
    # 返回预测结果
    return pred

# 测试预测函数
test_image_path = "99657241.jpeg"
result = predict(test_image_path)
print("Predicted traits: ", result)
