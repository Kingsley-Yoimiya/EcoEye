from django.urls import path
from .views.share_view import ShareView

urlpatterns = [
    path('share/', ShareView.as_view(), name='share'),
]
