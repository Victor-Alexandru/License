from django.db import models


# Create your models here.

class Skill(models.Model):
    # TODO: enums for skills and Domain Skill
    name = models.TextField(null=True, blank=True)


class Notification(models.Model):
    isVideo = models.BooleanField(default=False)
    isMessage = models.BooleanField(default=True)
    message = models.TextField(null=True, blank=True)
    # TODO: enums for colors
    background_color = models.CharField(null=False, blank=False, max_length=250)
    # TODO: add the video for notification
