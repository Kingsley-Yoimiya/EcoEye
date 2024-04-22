s# controllers/history.py
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import HistoryRecord  # Assuming you have a HistoryRecord model defined

@api_view(['GET'])
def get_history(request, user_id):
    history_records = HistoryRecord.objects.filter(user_id=user_id)
    # Assuming you have a method to serialize your history records
    return Response(serialize_history_records(history_records))

@api_view(['POST'])
def reanalyze_record(request, record_id):
    # Your reanalysis logic here
    return Response({'message': 'Record reanalyzed successfully'})

@api_view(['DELETE'])
def delete_record(request, record_id):
    try:
        record = HistoryRecord.objects.get(id=record_id)
        record.delete()
        return Response({'message': 'Record deleted successfully'})
    except HistoryRecord.DoesNotExist:
        return Response({'error': 'Record not found'}, status=status.HTTP_404_NOT_FOUND)

