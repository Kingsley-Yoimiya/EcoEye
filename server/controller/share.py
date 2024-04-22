# controllers/share.py
from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['POST'])
def share_content(request):
    platform = request.data.get('platform')
    content = request.data.get('content')
    # Your sharing logic here, e.g., calling external APIs to share content
    return Response({'message': f'Content shared to {platform} successfully'})

