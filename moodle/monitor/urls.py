from django.urls import path
from monitor import views

urlpatterns = [
    path('notifications/', views.NotificationList.as_view()),
    path('notifications/<int:pk>/', views.NotificationDetail.as_view()),
    path('skills/', views.SkillList.as_view()),
    path('skills/<int:pk>/', views.SkillDetail.as_view()),
]
