from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token
from monitor import views

urlpatterns = [
    path('api-token-auth/', obtain_auth_token, name='api_token_auth'),
    path('notifications/', views.NotificationList.as_view()),
    path('notifications/<int:pk>/', views.NotificationDetail.as_view()),
    path('skills/', views.SkillList.as_view()),
    path('skills/<int:pk>/', views.SkillDetail.as_view()),
    path('hello/', views.HelloView.as_view(), name='hello'),
    path('users/', views.UserList.as_view()),
    path('users/<int:pk>/', views.UserDetail.as_view()),
    path('groups/', views.GroupList.as_view()),
    path('groups/<int:pk>/', views.GroupDetail.as_view()),
]
