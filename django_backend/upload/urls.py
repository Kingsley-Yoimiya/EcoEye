from django.urls import path
from .views import UploadView, AnalysisView
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('upload', UploadView.as_view(), name='upload'),
    path('analyze/', AnalysisView.as_view(), name='analyze'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
