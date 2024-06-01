# EcoEye

[中文](./README.md) | [English](./README-en.md)

## 简介

EcoEye 是一个能检测植物各项指标（如木材密度，比叶面积）的应用，其核心是基于深度学习的神经网络以及 GPT-4o 的识别、分析、提出建议的能力，EcoEye 能帮助你仅仅通过一张图片就能快速获取一个植物的大致指标。

同时，EcoEye 也是我的软件工程实验班的项目，全程使用 ChatGPT 开发。

EcoEye 的具体架构为：前端 Flutter 和 后端 Django。

你可以在 [这里](https://kingsley-yoimiya.github.io/post/GPT-CODE.html) 看到具体开发过程（代码生成阶段）。

## 部署

### 环境准备

请先参考 [Flutter 官网](https://flutter.dev/) 完成 Flutter 配置。

推荐 Python 使用 3.10 版本。

### 克隆仓库

```bash
git clone https://github.com/Kingsley-Yoimiya/EcoEye.git
```

### 后端配置

```bash
cd EcoEye
pip install -r django_backend/requirements.txt
```

### 启动

后端启动：

```bash
cd django_backend
python manage.py runserver
```

前端调试启动：

```bash
cd flutter
flutter run
```

## 详细配置

### 后端地址

因为我一直在本地调试，并没有构建并且放到手机上实测，于是，默认前后端信息传递的地址为 `http://127.0.0.1:8000/api`，你可以在 `flutter_app/lib/services/api_service.dart` 处修改 `baseUrl` 更改这个地址。

**如果前后端无法正确匹配，请检查该地址。**

### GPT keys

请在 `django_backend/gpt_model/config.json` 处修改 key 的内容（如果没有该文件，请先创建），文件内容为（假设你的 key 为 `sk-114514`）：

```json
{
    "openai_api_key": "sk-114514"
}
```

如果没有 API key，建议生成部分功能将无法使用。