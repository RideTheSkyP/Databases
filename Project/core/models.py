from django.db import models


class Transfers(models.Model):
	userId = models.IntegerField()
	transferFrom = models.IntegerField()
	transferTo = models.IntegerField()
	amount = models.FloatField()
	money = models.FloatField(default=50000)
