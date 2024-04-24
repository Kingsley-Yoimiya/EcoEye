from django.db import models
from authentication.models import User

class Record(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='records')
    photo = models.ImageField(upload_to='uploads/')
    analysisResults = models.JSONField()
    timestamp = models.DateTimeField(auto_now_add=True)
