from django import forms
from .models import Carro

class CarroForm(forms.ModelForm):
    class Meta:
        model = Carro
        fields = ['marca', 'modelo', 'accesorios']  # incluye 'accesorios' en el formulario
        