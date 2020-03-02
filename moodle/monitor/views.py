from django.shortcuts import render
from monitor.models import Notification, Skill, Group
from monitor.serializers import NotificationSerializer, UserSerializer, SkillSerializer, GroupSerializer
from rest_framework import generics
# from django.contrib.auth.models import User
from monitor.models import User
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated


# Create your views here.

class NotificationList(generics.ListCreateAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer


class NotificationDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer


class SkillList(generics.ListCreateAPIView):
    queryset = Skill.objects.all()
    serializer_class = SkillSerializer


class SkillDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Skill.objects.all()
    serializer_class = SkillSerializer


class UserList(generics.ListCreateAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        # import  ipdb;
        # ipdb.set_trace()
        locality = self.request.query_params.get("locality")
        if locality:
            return User.objects.all().filter(location=locality)
        else:
            return User.objects.all()


class UserDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def perform_update(self, serializer):
        print(serializer)
        serializer.save()


class GroupList(generics.ListCreateAPIView):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer

    def perform_create(self, serializer):
        import ipdb;
        ipdb.set_trace()
        serializer.save(owner=self.request.user)
        print("------------------------")
        print("HEREEE")
        print("------------------------")


class GroupDetail(generics.RetrieveAPIView):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer


class HelloView(APIView):
    permission_classes = (IsAuthenticated,)  # <-- And here

    def get(self, request):
        content = {'message': 'Hello, World!'}
        return Response(content)
