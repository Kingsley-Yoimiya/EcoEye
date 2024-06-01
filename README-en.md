# EcoEye

[中文](./README.md) | [English](./README-en.md)


## What is EcoEye？

EcoEye is an app that can detect various plant metrics such as wood density and leaf area ratio using a deep learning neural network at its core. It's powered by GPT-4o, which enables it to identify, analyze, and offer recommendations based on images alone. This means users can quickly get an idea of their plants' health just from a photo.

Not only is EcoEye my software engineering project for the experimental class, but it was also developed entirely with ChatGPT.

Here's how the architecture breaks down: Frontend - Flutter; Backend - Django.

You can check out the specific development process (code generation stage) over [here](https://kingsley-yoimiya.github.io/post/GPT-CODE.html).

## Deployment

### Environment Preparation

Please complete Flutter configuration according to the [official website](https://flutter.dev/) first.

It is recommended to use Python version 3.10.

### Clone Repository

```sh
git clone https://github.com/Kingsley-Yoimiya/EcoEye.git
```

### Backend Configuration

```sh
cd EcoEye
pip install -r django_backend/requirements.txt
```

### Startup

Start backend:

```sh
cd django_backend
python manage.py runserver
```

Run frontend in debug mode:

```sh
cd flutter
flutter run
```

## Detailed Configuration

### Backend Address

Since I have been debugging locally without deploying to mobile devices, the default address for communication between the frontend and backend is set to `http://127.0.0.1:8000/api`. You can modify this address in `flutter_app/lib/services/api_service.dart` under `baseUrl`.

**If there is no proper match between the frontend and backend, please verify this address.**

### GPT Keys

Please update the content in `django_backend/gpt_model/config.json` with your OpenAI API key (if one does not exist, create it). The file should look something like this if your key is `sk-114514`:

```json
{
  "openai_api_key": "sk-114514"
}
```

Without an API key, certain features will be limited or unavailable.