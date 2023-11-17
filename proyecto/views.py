from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User
from django.shortcuts import render, redirect, get_object_or_404
from .models import Usuario, Empleado, Sucursal, Gerente, JefeTaller, AsesorComercial
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth import login, logout, authenticate
from django.db import IntegrityError
from django.utils import timezone
from django.contrib.auth.decorators import login_required
from .forms import EmpleadoForm, GerenteForm, JefeTallerForm, AsesorComercialForm, SucursalForm, UsuarioForm
from django.db import IntegrityError, transaction
from django.core.exceptions import ValidationError
from django.contrib import messages
from django.http import JsonResponse
from django.forms import model_to_dict

def home(request):
    return render(request, 'home.html')

def signIn(request):
    if request.method == 'GET':
        form = UsuarioForm()
        return render(request, 'SignIn.html', {'form': form})
    else:
        id_usuario = request.POST['id_usuario']
        contrasena = request.POST['contrasena']
        try:
            user = Usuario.objects.get(id_usuario=id_usuario)
            if contrasena == user.contrasena:
                print("Ingreso correcto")
                return redirect('home')
            else:
                return render(request, 'SignIn.html', {"form": UsuarioForm(), "error": "Contraseña incorrecta."})
        except Usuario.DoesNotExist:
            return render(request, 'SignIn.html', {"form": UsuarioForm(), "error": "Usuario no existe."})


def empleado_cargo_signup(request):
  if request.method == 'POST':
    form = EmpleadoForm(request.POST)
    if form.is_valid():
      empleado = form.save()
      messages.success(request, 'Empleado registrado exitosamente')
      return redirect('SignIn')
  else: 
    form = EmpleadoForm()
  return render(request, 'EmpleadoForm.html', {'form': form})

def get_form_fields(request):
    id_empleado = request.GET.get('id_empleado', None)
    empleado = Empleado.objects.get(id_empleado=id_empleado)

    if empleado.cargo == 'GERENTE':
        form = GerenteForm()
    elif empleado.cargo == 'JEFE DE TALLER':
        form = JefeTallerForm()
    elif empleado.cargo == 'ASESOR COMERCIAL':
        form = AsesorComercialForm()
    else:
        form = None

    form_fields = [field.label for field in form] if form else []

    return JsonResponse({'form_fields': form_fields})

def asignar_cargo(request):
    if request.method == 'POST':
        id_empleado = request.POST['empleado']
        empleado = Empleado.objects.get(id_empleado=id_empleado)

        if empleado.cargo == 'GERENTE':
            form = GerenteForm(request.POST)
            if form.is_valid():
                gerente = form.save(commit=False)
                gerente.id_gerente = empleado
                gerente.save()
                messages.success(request, 'Cargo asignado con éxito.')
            else:
                messages.error(request, 'Error al asignar cargo.')
        elif empleado.cargo == 'JEFE DE TALLER':
            form = JefeTallerForm(request.POST)
            if form.is_valid():
                jefe_taller = form.save(commit=False)
                jefe_taller.id_jefetaller = empleado
                jefe_taller.save()
                messages.success(request, 'Cargo asignado con éxito.')
            else:
                messages.error(request, 'Error al asignar cargo.')
        elif empleado.cargo == 'ASESOR COMERCIAL':
            form = AsesorComercialForm(request.POST)
            if form.is_valid():
                asesor_comercial = form.save(commit=False)
                asesor_comercial.id_asesor = empleado
                asesor_comercial.save()
                messages.success(request, 'Cargo asignado con éxito.')
            else:
                messages.error(request, 'Error al asignar cargo.')
        else:
            messages.error(request, 'Cargo no reconocido.')

    empleados = Empleado.objects.values_list('id_empleado', 'nombre')
    return render(request, 'CargoForm.html', {'empleados': empleados})

def usuarioSignUp(request):
    if request.method == 'POST':
        form = UsuarioForm(request.POST)
        empleado_id = request.POST['empleado']
        empleado = get_object_or_404(Empleado, id_empleado=empleado_id)

        if form.is_valid():
           try:
                usuario = form.save(commit=False)
                usuario.empleado = empleado
                usuario.save()
                return redirect('SignIn')  
           except Exception as e:
                form.add_error(None, f'Error: {e}')
    else:
        form = UsuarioForm()

    empleados = Empleado.objects.all()
    return render(request, 'UsuarioForm.html', {'form': form, 'empleados': empleados})


def ingresarSucursal(request):
    if request.method == 'POST':
        form = SucursalForm(request.POST)
        if form.is_valid():
            try:
                cod_sucursal = form.cleaned_data['cod_sucursal']
                if Sucursal.objects.filter(cod_sucursal=cod_sucursal).exists():
                    raise ValidationError('Este código de sucursal ya existe.')
                form.save()
                print("Ingreso exitoso:", form.cleaned_data)  # Muestra los datos ingresados en consola
                return redirect('home')
            except ValidationError as e:
                form.add_error('cod_sucursal', e)
    else:
        form = SucursalForm()

    context = {
        'form': form,
    }
    return render(request, 'SucursalForm.html', context)

