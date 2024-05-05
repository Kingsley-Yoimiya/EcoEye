from rest_framework import serializers
from .models import Record, Advice

class RecordSerializer(serializers.ModelSerializer):
    recordId = serializers.IntegerField(source='id', read_only=True)
    userId = serializers.IntegerField(source='user_id', read_only=True)
    timestamp = serializers.DateTimeField()

    class Meta:
        model = Record
        fields = ('recordId', 'userId', 'timestamp', 'analysisResults')

class AdviceSerializer(serializers.ModelSerializer):
    adviceId = serializers.IntegerField(source='id', read_only=True)
    recordId = serializers.IntegerField(source='record_id', read_only=True)
    timestamp = serializers.DateTimeField()

    class Meta:
        model = Advice
        fields = ('adviceId', 'recordId', 'adviceText', 'timestamp')
