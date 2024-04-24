from django.urls import path
from .views import HistoryView, AdviceView

urlpatterns = [
    path('records/<str:userId>/', HistoryView.as_view(), name='history'),
    path('advice/<int:recordId>/', AdviceView.as_view(), name='advice'),
]
