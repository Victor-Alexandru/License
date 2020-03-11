from django.contrib.auth.models import User
from django.db.models import Q
from django.shortcuts import render
from rest_framework.decorators import api_view
from django.utils import timezone
from monitor.models import Notification, Skill, Group, Site_User, UserMessage
from monitor.serializers import NotificationSerializer, SkillSerializer, GroupSerializer, UserSerializer, \
    SiteUserSerializer, UserMessageSerializer
from rest_framework import generics
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

    def perform_create(self, serializer):
        serializer.save()


class UserDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()

    serializer_class = UserSerializer

    def perform_update(self, serializer):
        serializer.save()


class SiteUserList(generics.ListCreateAPIView):
    serializer_class = SiteUserSerializer

    def get_queryset(self):
        locality = self.request.query_params.get("locality")
        if locality:
            return Site_User.objects.all().filter(location=locality)
        else:
            return Site_User.objects.all()

    def perform_create(self, serializer):
        serializer.save()


class SiteUserDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Site_User.objects.all()

    serializer_class = SiteUserSerializer

    def perform_update(self, serializer):
        serializer.save()


class UserMessageList(generics.ListCreateAPIView):
    serializer_class = UserMessageSerializer

    def get_queryset(self):
        first_user_id = self.request.query_params.get("first_user_id")
        second_user_id = self.request.query_params.get("second_user_id")

        if first_user_id and second_user_id:
            first_user = Site_User.objects.all().get(pk=first_user_id)
            second_user = Site_User.objects.all().get(pk=second_user_id)

            return UserMessage.objects.all().filter(
                Q(owner=first_user, to_user_msg=second_user) | Q(owner=second_user, to_user_msg=first_user)).order_by(
                'time')

        return UserMessage.objects.all()

    def perform_create(self, serializer):
        serializer.save(time=timezone.now())


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


@api_view(['POST'])
def auth_user(request):
    """
    Retrieve, update or delete a code snippet.
    """
    print("-----------------------------------")
    print("In authentication")
    print("-----------------------------------")
    # import ipdb;
    # ipdb.set_trace()
    if request.method == 'POST':
        username = request.data.get('username')
        password = request.data.get('password')
        user = User.objects.all().filter(username=username, password=password)
        if len(user) == 0:
            return Response({"error": True, "error_msg": "Invalid credentitals"}, status=200)
        else:
            return Response({"error": False, "user": {
                "id": user[0].id,
                "username": username,
                "password": password,
            }}, status=200)
