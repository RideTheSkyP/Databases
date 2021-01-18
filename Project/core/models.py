from django.db import models


class Player(models.Model):
	userId = models.IntegerField()
	privilege = models.IntegerField(default=0)


class PlayerStats(models.Model):
	userId = models.IntegerField()
	scoredPoints = models.IntegerField()
	averagePoints = models.IntegerField()
	teamContribution = models.FloatField()
	gamesAmount = models.IntegerField(default=0)
	totalKills = models.IntegerField()
	totalAssists = models.IntegerField()
