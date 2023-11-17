from django.contrib.auth.hashers import make_password
from .models import Usuario

def encrypt_passwords():
    usuarios = Usuario.objects.all()
    for usuario in usuarios:
        password = make_password(usuario.contrasena)
        usuario.contrasena = password
        usuario.save()