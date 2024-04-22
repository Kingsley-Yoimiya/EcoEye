from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    # 如果需要额外的字段，可以在这里添加
    # 例如:
    # phone_number = models.CharField(max_length=20, blank=True, null=True)
    
    def __str__(self):
        return self.username
