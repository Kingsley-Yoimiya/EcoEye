from django.urls import path
from .views import HistoryView, AdviceView, ResultView, DeleteView, ReanalyzeView

urlpatterns = [
    path('records/<int:userId>/', HistoryView.as_view(), name='history'),
    path('result/<int:recordId>/', ResultView.as_view(), name='result'),
    path('advice/<int:recordId>/', AdviceView.as_view(), name='advice'),
    path('delete/<int:recordId>/', DeleteView.as_view(), name='delete_record'),
    path('reanalyze/<int:recordId>/', ReanalyzeView.as_view(), name='reanalyze_record'),
]
