from django.db import models


# Create your models here.
class User(models.Model):
    first_name = models.CharField(max_length=250, null=True, blank=True)
    surname = models.CharField(max_length=250, null=True, blank=True)
    user_name = models.CharField(max_length=250, null=True, blank=True)
    email = models.EmailField()
    password = models.TextField(null=True, blank=True)
    # TODO: enums for Location ,maybe county added
    location = models.TextField(null=True, blank=True)
    # TODO: add image file


class Skill(models.Model):
    # TODO: enums for skills and Domain Skill
    name = models.TextField(null=True, blank=True)


class UserSkill(models.Model):
    Beginner = 'BG'
    Intermiediate = 'IT'
    Expert = 'EX'
    Master = 'MS'
    LEVELS = (
        ('BG', 'Beginner'),
        ('IT', 'Intermiediate'),
        ('EX', 'Expert'),
        ('MS', 'Master'),
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE)
    # TODO: enums for level
    level = models.CharField(max_length=2,
                             choices=LEVELS,
                             default=Beginner, )
    yearsOfExperience = models.IntegerField()


class Notification(models.Model):
    isVideo = models.BooleanField(default=False)
    isMessage = models.BooleanField(default=True)
    message = models.TextField(null=True, blank=True)
    # TODO: enums for colors
    background_color = models.CharField(null=False, blank=False, max_length=250)
    # TODO: add the video for notification
