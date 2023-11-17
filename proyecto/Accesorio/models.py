from django.db import models


class Accesorio(models.Model):
    nombre = models.CharField(max_length=200)

class Vehiculo(models.Model):
    # otros campos...
    accesorios = models.ManyToManyField(Accesorio)