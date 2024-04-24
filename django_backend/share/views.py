from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

class ShareView(APIView):
    def post(self, request):
        # 这里可以添加逻辑来处理分享到特定平台的逻辑
        # 例如，使用第三方平台的API来分享内容
        # 由于这涉及到第三方API的使用，这里我们仅模拟分享过程
        platform = request.data.get('platform')
        content = request.data.get('content')
        # 模拟分享过程
        print(f"Sharing to {platform} with content: {content}")
        return Response({"message": "Content shared successfully"}, status=status.HTTP_200_OK)
