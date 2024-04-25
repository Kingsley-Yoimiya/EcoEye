from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Record, Advice
from .serializers import RecordSerializer, AdviceSerializer

class HistoryView(APIView):
    def get(self, request, userId):
        records = Record.objects.filter(userId=userId)
        serializer = RecordSerializer(records, many=True)
        return Response(serializer.data)

class AdviceView(APIView):
    def get(self, request, recordId):
        advice = Advice.objects.filter(record_id=recordId)
        serializer = AdviceSerializer(advice, many=True)
        return Response(serializer.data)

