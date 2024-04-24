from django.urls import path
from .views import HistoryListAPIView, AdviceAPIView

urlpatterns = [
    path('records/', HistoryListAPIView.as_view(), name='history-records'),
    path('advice/<int:pk>/', AdviceAPIView.as_view(), name='advice-detail'),
]
