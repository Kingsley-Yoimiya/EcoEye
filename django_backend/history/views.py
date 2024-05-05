from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from .models import Record, Advice
from .serializers import RecordSerializer, AdviceSerializer
from rest_framework.authtoken.models import Token

class HistoryView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, userId):
        user = request.user
        # Ensure token matches the user
        if not Token.objects.filter(user=user, key=request.auth.key).exists():
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)

        records = Record.objects.filter(userId=userId).order_by('timestamp')
        serializer = RecordSerializer(records, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class AdviceView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, recordId):
        user = request.user
        # Ensure token matches the user
        if not Token.objects.filter(user=user, key=request.auth.key).exists():
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            record = Record.objects.get(id=recordId, userId=user.id)
        except Record.DoesNotExist:
            return Response({"message": "Record not found"}, status=status.HTTP_404_NOT_FOUND)

        advice = Advice.objects.filter(record_id=recordId)
        serializer = AdviceSerializer(advice, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
