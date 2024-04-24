from rest_framework import status, views
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

class ShareView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # 示例中简化了分享逻辑，实际项目中可能需要与外部服务进行交互
        platform = request.data.get('platform')
        content = request.data.get('content')
        # 这里可以添加将内容分享到指定平台的代码
        # 返回一个模拟的成功响应
        return Response({"message": f"Content successfully shared to {platform}."}, status=status.HTTP_200_OK)
