from django.urls import path
from .views import ShareView

urlpatterns = [
    path('share/', ShareView.as_view(), name='share'),
]
