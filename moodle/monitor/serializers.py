from rest_framework import serializers
from monitor.models import Notification, Skill


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['id', 'isVideo', 'isMessage', 'message', 'background_color', ]


class SkillSerializer(serializers.ModelSerializer):
    class Meta:
        model = Skill
        fields = ['id', 'name', ]
