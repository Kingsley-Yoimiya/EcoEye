from django.urls import path
from .views import HistoryView, AdviceView, ResultView

urlpatterns = [
    path('records/<int:userId>/', HistoryView.as_view(), name='history'),
    path('result/<int:recordId>/', ResultView.as_view(), name='result'),
    path('advice/<int:recordId>/', AdviceView.as_view(), name='advice'),
]
