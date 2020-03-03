from rest_framework import serializers
from monitor.models import Notification, Skill, Group, Survey, EvaluationSession, SurveyQuestion, Site_User
from django.contrib.auth.models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'password', 'email']


class SiteUserSerializer(serializers.ModelSerializer):
    groupings = serializers.PrimaryKeyRelatedField(many=True, queryset=Group.objects.all())

    class Meta:
        model = Site_User
        fields = ['id', 'first_name', 'surname', 'password', 'location', 'groupings']


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['id', 'isVideo', 'isMessage', 'message', 'background_color', ]


class SkillSerializer(serializers.ModelSerializer):
    class Meta:
        model = Skill
        fields = ['id', 'name', ]


class GroupSerializer(serializers.ModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')

    class Meta:
        model = Group
        fields = ['id', 'name', 'group_size', 'estimated_work_duration', 'owner']


# class UserSerializer(serializers.ModelSerializer):
#     groups = serializers.PrimaryKeyRelatedField(many=True, queryset=Group.objects.all())
#
#     class Meta:
#         model = User
#         fields = ['id', 'first_name', 'surname', 'user_name', 'email', 'password', 'location', 'groups']


class SurveySerializer(serializers.ModelSerializer):
    class Meta:
        model = Survey
        fields = ['id', 'name', 'description', 'aim_for_survey', ]


class EvaluationSessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = EvaluationSession
        fields = ['id', 'start_date', 'end_date', 'name', ]


class SurveyQuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = SurveyQuestion
        fields = ['id', 'text', 'points', 'type', ]
