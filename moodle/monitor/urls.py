from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token
from monitor import views

urlpatterns = [
    path('auth', views.auth_user, name='api_auth'),
    path('notifications/', views.NotificationList.as_view()),
    path('notifications/<int:pk>/', views.NotificationDetail.as_view()),
    path('skills/', views.SkillList.as_view()),
    path('skills/<int:pk>/', views.SkillDetail.as_view()),
    path('hello/', views.HelloView.as_view(), name='hello'),
    path('users/', views.UserList.as_view()),
    path('users/<int:pk>/', views.UserDetail.as_view()),
    path('site-users/', views.SiteUserList.as_view()),
    path('site-users/<int:pk>/', views.SiteUserDetail.as_view()),
    path('user-messages/', views.UserMessageList.as_view()),
    path('groups/', views.GroupList.as_view()),
    path('groups/<int:pk>/', views.GroupDetail.as_view()),
]
