# Generated by Django 2.2 on 2019-12-14 14:05

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Group',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(blank=True, max_length=250, null=True)),
                ('group_size', models.IntegerField(blank=True, null=True)),
                ('estimated_work_duration', models.IntegerField(blank=True, null=True)),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='groupings', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Notification',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('isVideo', models.BooleanField(default=False)),
                ('isMessage', models.BooleanField(default=True)),
                ('message', models.TextField(blank=True, null=True)),
                ('background_color', models.CharField(max_length=250)),
            ],
        ),
        migrations.CreateModel(
            name='Skill',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.TextField(blank=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='Survey',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(blank=True, max_length=250, null=True)),
                ('description', models.TextField(blank=True, null=True)),
                ('aim_for_survey', models.TextField(blank=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='UserSkill',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('level', models.CharField(choices=[('BG', 'Beginner'), ('IT', 'Intermiediate'), ('EX', 'Expert'), ('MS', 'Master')], default='BG', max_length=2)),
                ('yearsOfExperience', models.IntegerField()),
                ('skill', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='monitor.Skill')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='SurveyQuestion',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('type', models.CharField(blank=True, max_length=250, null=True)),
                ('points', models.IntegerField()),
                ('text', models.TextField()),
                ('survey', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='monitor.Survey')),
            ],
        ),
        migrations.CreateModel(
            name='SurveyAnswer',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('isValid', models.BooleanField(default=False)),
                ('text', models.TextField()),
                ('points_get', models.IntegerField()),
                ('survey_question', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='monitor.SurveyQuestion')),
            ],
        ),
        migrations.CreateModel(
            name='GroupNotification',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateField(null=True)),
                ('priority', models.CharField(choices=[('LW', 'LOW'), ('MD', 'MEDIUM'), ('HG', 'HIGH')], default='LW', max_length=2)),
                ('group', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='monitor.Group')),
                ('notification', models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, to='monitor.Notification')),
            ],
        ),
        migrations.AddField(
            model_name='group',
            name='skill',
            field=models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, to='monitor.Skill'),
        ),
        migrations.CreateModel(
            name='EvaluationSession',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('start_date', models.DateField()),
                ('end_date', models.DateField()),
                ('name', models.CharField(blank=True, max_length=250, null=True)),
                ('group', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='monitor.Group')),
                ('survey', models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, to='monitor.Survey')),
            ],
        ),
        migrations.CreateModel(
            name='UserGroup',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('isTeacher', models.BooleanField(default=False)),
                ('isLearner', models.BooleanField(default=True)),
                ('start_at', models.DateField(null=True)),
                ('group', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='monitor.Group')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'unique_together': {('user', 'group')},
            },
        ),
    ]
