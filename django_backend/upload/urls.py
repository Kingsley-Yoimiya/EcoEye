from django.urls import path
from .views.upload_view import UploadView
from .views.analysis_view import AnalysisView

urlpatterns = [
    path('upload/', UploadView.as_view(), name='file-upload'),
    path('analysis/', AnalysisView.as_view(), name='file-analysis'),
]
