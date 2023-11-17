from django.urls import path
from . import views
from django.shortcuts import render, get_object_or_404, redirect
from .models import Vehiculo
from .forms import AccesorioForm

urlpatterns = [
    # otras rutas...
    path('carro/editar/<int:id>/', views.editar_carro, name='editar_carro'),
]
def crear_accesorio(request, id):
    vehiculo = get_object_or_404(Vehiculo, id=id)
    if request.method == 'POST':
        form = AccesorioForm(request.POST)
        if form.is_valid():
            accesorio = form.save(commit=False)
            accesorio.vehiculo = vehiculo
            accesorio.save()
            return redirect('detalle_vehiculo', id=id)
    else:
        form = AccesorioForm()
    return render(request, 'crear_accesorio.html', {'form': form})
