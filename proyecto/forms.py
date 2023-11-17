from django import forms
from .models import VehiculoCliente
from .models import Empleado
from .models import Sucursal
from .models import Usuario
from .models import AsesorComercial
from .models import Cliente
from .models import JefeTaller
from .models import Gerente
from django.forms import ModelForm, DateInput

class EmpleadoForm(forms.ModelForm):
    cargo = forms.ChoiceField(choices=[('', '---------'), ('GERENTE', 'Gerente'), ('JEFE DE TALLER', 'Jefe de Taller'), ('ASESOR COMERCIAL', 'Asesor Comercial')])
    class Meta:
        model = Empleado
        fields = ['id_empleado', 'nombre', 'apellido', 'direccion', 'fecha_inicio', 'salario', 'cargo']
        widgets = {
            'fecha_inicio': DateInput(attrs={'type': 'date'}),
        }
class SucursalForm(forms.ModelForm):
    class Meta:
        model = Sucursal
        fields = ['cod_sucursal', 'nombre', 'direccion', 'ciudad']

class UsuarioForm(forms.ModelForm):
    contrasena = forms.CharField(widget=forms.PasswordInput)
    class Meta:
        model = Usuario
        fields = ['id_usuario', 'id_empleado', 'contrasena']
        widgets = {
            'id_empleado': forms.HiddenInput()
        }

class AsesorComercialForm(forms.ModelForm):
    cod_sucursal = forms.ModelChoiceField(queryset=Sucursal.objects.all())

    class Meta:
        model = AsesorComercial
        fields = ['correo', 'telefono', 'cod_sucursal']

class JefeTallerForm(forms.ModelForm):
    cod_sucursal = forms.ModelChoiceField(queryset=Sucursal.objects.all())
    class Meta:
        model = JefeTaller
        fields = ['correo', 'telefono', 'cod_sucursal']

class GerenteForm(forms.ModelForm):
    cod_sucursal = forms.ModelChoiceField(queryset=Sucursal.objects.all())
    class Meta:
        model = Gerente
        fields = ['correo', 'telefono', 'cod_sucursal']

class VehiculoClienteForm(forms.ModelForm):
    class Meta:
        model = VehiculoCliente
        fields = ['placa', 'marca', 'modelo', 'anio', 'linea', 'color', 'VIN', 'tipo_combustible', 'id_cliente']

class ClienteForm(forms.ModelForm):
    class Meta:
        model = Cliente
        fields = ['nombre', 'apellido', 'telefono', 'correo', 'direccion']

