# Generated by Django 2.2 on 2020-03-10 13:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('monitor', '0002_usermessage'),
    ]

    operations = [
        migrations.AddField(
            model_name='usermessage',
            name='time',
            field=models.DateTimeField(blank=True, null=True),
        ),
    ]
