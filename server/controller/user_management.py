from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.authtoken.models import Token

@api_view(['POST'])
def register(request):
    username = request.data.get('username')
    password = request.data.get('password')
    email = request.data.get('email')
    if not username or not password or not email:
        return Response({'error': 'Missing information'}, status=status.HTTP_400_BAD_REQUEST)
    
    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)
    
    user = User.objects.create_user(username, email, password)
    token, created = Token.objects.get_or_create(user=user)
    return Response({'message': 'User created successfully', 'token': token.key}, status=status.HTTP_201_CREATED)

@api_view(['POST'])
def login(request):
    username = request.data.get('username')
    password = request.data.get('password')
    user = authenticate(username=username, password=password)
    if user is not None:
        token, _ = Token.objects.get_or_create(user=user)
        return Response({'message': 'Login successful', 'token': token.key})
    else:
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
