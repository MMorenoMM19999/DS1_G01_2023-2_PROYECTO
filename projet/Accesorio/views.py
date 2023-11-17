from django.shortcuts import render, redirect, get_object_or_404

from .forms import AccesorioForm
from .models import Vehiculo

def crear_accesorio(request, id):
    vehiculo = get_object_or_404(Vehiculo, id=id)
    if request.method == 'POST':
        form = AccesorioForm(request.POST)
        if form.is_valid():
            accesorio = form.save()
            vehiculo.accesorios.add(accesorio)
            return redirect('detalles_vehiculo', id=vehiculo.id)
    else:
        form = AccesorioForm()
    return render(request, 'crear_accesorio.html', {'form': form})

