from django.db import models

class Record(models.Model):
    userId = models.CharField(max_length=100)
    photo = models.ImageField(upload_to='uploads/')
    analysisResults = models.JSONField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Record {self.id} for User {self.userId}"

class Advice(models.Model):
    record = models.ForeignKey(Record, on_delete=models.CASCADE)
    adviceText = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Advice {self.id} for Record {self.record.id}"

