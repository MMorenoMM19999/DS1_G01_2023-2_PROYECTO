from django.urls import path
from . import views

urlpatterns = [
    path('empleado_cargo_signup/<str:tipo_usuario>/', views.empleado_cargo_signup, name='empleado_cargo_signup'),
    # Otras rutas específicas de la aplicación Application...
]