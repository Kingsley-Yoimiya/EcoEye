from django.db import models
# 假设 Record 和 Advice 位于同一应用的 models 目录下
from .record import Record  # 从 record.py 中导入 Record 模型

class Advice(models.Model):
    record = models.OneToOneField(Record, on_delete=models.CASCADE, related_name='advice')
    adviceText = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
