# project_root/urls.py
from django.urls import path
from django.contrib import admin
from rest_framework.urlpatterns import format_suffix_patterns
from controllers import user_management, history, upload_analysis, share

urlpatterns = [
    path('admin/', admin.site.urls),
    # User management URLs
    path('api/register/', user_management.register, name='register'),
    path('api/login/', user_management.login, name='login'),
    # History URLs
    path('api/history/<int:user_id>/', history.get_history, name='get_history'),
    path('api/history/reanalyze/<int:record_id>/', history.reanalyze_record, name='reanalyze_record'),
    path('api/history/delete/<int:record_id>/', history.delete_record, name='delete_record'),
    # Upload and Analysis URLs
    path('api/upload/', upload_analysis.upload_photo, name='upload_photo'),
    path('api/advice/<int:result_id>/', upload_analysis.get_care_advice, name='get_care_advice'),
    # Share URLs
    path('api/share/', share.share_content, name='share_content'),
]

urlpatterns = format_suffix_patterns(urlpatterns)

