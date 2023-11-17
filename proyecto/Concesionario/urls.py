"""
URL configuration for Concesionario project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from Application import views

urlpatterns = [
    path('', views.home, name='home'),
    path('admin/', admin.site.urls),
    path('SignIn/', views.signIn, name='SignIn'),
    path('ingresar_sucursal/', views.ingresarSucursal, name='ingresar_sucursal'),
    path('ingresar_usuario/', views.usuarioSignUp, name='usuarioSignUp'),
    path('empleado_cargo_signup/', views.empleado_cargo_signup, name='empleado_cargo_signup'),
    path('asignar_cargo/', views.asignar_cargo, name='asignar_cargo'),
    path('get_form_fields/', views.get_form_fields, name='get_form_fields'),
]
