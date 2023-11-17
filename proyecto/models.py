from django.db import models
class Empleado(models.Model):
    id_empleado = models.IntegerField(primary_key=True)
    nombre = models.CharField(max_length=255)
    apellido = models.CharField(max_length=255)
    direccion = models.CharField(max_length=255)
    fecha_inicio = models.DateField()
    salario = models.DecimalField(max_digits=12, decimal_places=2)
    CARGO_CHOICES = [
        ('GERENTE', 'Gerente'),
        ('JEFE DE TALLER', 'Jefe de Taller'),
        ('ASESOR COMERCIAL', 'Asesor Comercial'),
    ]
    cargo = models.CharField(max_length=20, choices=CARGO_CHOICES)

class Sucursal(models.Model):
    cod_sucursal = models.IntegerField(primary_key=True)
    nombre = models.CharField(max_length=255)
    direccion = models.CharField(max_length=255)
    ciudad = models.CharField(max_length=255)

class JefeTaller(models.Model):
    id_jefetaller = models.OneToOneField(Empleado, on_delete=models.CASCADE, primary_key=True)
    correo = models.EmailField()
    telefono = models.CharField(max_length=255)
    cod_sucursal = models.ForeignKey(Sucursal, on_delete=models.CASCADE)

class AsesorComercial(models.Model):
    id_asesor = models.OneToOneField(Empleado, on_delete=models.CASCADE, primary_key=True)
    correo = models.EmailField()
    telefono = models.CharField(max_length=255)
    cod_sucursal = models.ForeignKey(Sucursal, on_delete=models.CASCADE)

class Gerente(models.Model):
    id_gerente = models.OneToOneField(Empleado, on_delete=models.CASCADE, primary_key=True)
    correo = models.EmailField()
    telefono = models.CharField(max_length=255)
    cod_sucursal = models.ForeignKey(Sucursal, on_delete=models.CASCADE)

class Usuario(models.Model):
    id_usuario = models.CharField(max_length=255, primary_key=True)
    id_empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    contrasena = models.CharField(max_length=255)

class Cliente(models.Model):
    id_cliente = models.IntegerField(primary_key=True)
    nombre = models.CharField(max_length=255)
    apellido = models.CharField(max_length=255)
    telefono = models.CharField(max_length=255)
    correo = models.EmailField()
    direccion = models.CharField(max_length=255)

class VehiculoCliente(models.Model):
    placa = models.CharField(max_length=255, primary_key=True)
    marca = models.CharField(max_length=255)
    modelo = models.CharField(max_length=255)
    anio = models.IntegerField()
    linea = models.CharField(max_length=255, default='')
    color = models.CharField(max_length=255)
    VIN = models.CharField(max_length=255)
    tipo_combustible = models.CharField(max_length=255)
    id_cliente = models.ForeignKey(Cliente, on_delete=models.CASCADE)

class OrdenReparacion(models.Model):
    numero_orden = models.AutoField(primary_key=True)
    id_cliente = models.ForeignKey(Cliente, on_delete=models.CASCADE)
    placa = models.ForeignKey(VehiculoCliente, on_delete=models.CASCADE)
    descripcion = models.TextField()
    id_jefetaller = models.ForeignKey(JefeTaller, on_delete=models.CASCADE)
    precio = models.DecimalField(max_digits=12, decimal_places=2)
    fecha_inicio = models.DateField()
    fecha_entrega = models.DateField()

class Repuestos(models.Model):
    referencia_repuesto = models.CharField(max_length=255, primary_key=True)
    nombre = models.CharField(max_length=255)
    marca = models.CharField(max_length=255)
    precio = models.DecimalField(max_digits=12, decimal_places=2)
    cod_sucursal = models.ForeignKey(Sucursal, on_delete=models.CASCADE)

class VehiculoNuevo(models.Model):
    VIN = models.CharField(max_length=255, primary_key=True)
    marca = models.CharField(max_length=255)
    modelo = models.CharField(max_length=255)
    anio = models.IntegerField()
    linea = models.CharField(max_length=255)
    color = models.CharField(max_length=255)
    tipo_combustible = models.CharField(max_length=255)
    precio = models.DecimalField(max_digits=12, decimal_places=2)
    descuento = models.IntegerField()
    cod_sucursal = models.ForeignKey(Sucursal, on_delete=models.CASCADE)

class Cotizacion(models.Model):
    id_cotizacion = models.AutoField(primary_key=True)
    fecha_cotizacion = models.DateField()
    id_cliente = models.ForeignKey(Cliente, on_delete=models.CASCADE)
    referencia_repuesto = models.ForeignKey(Repuestos, on_delete=models.CASCADE)
    VIN = models.ForeignKey(VehiculoNuevo, on_delete=models.CASCADE)
    cod_sucursal = models.ForeignKey(Sucursal, on_delete=models.CASCADE)
    descripcion = models.TextField()

class Accesorios(models.Model):
    id_accesorio = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=255)
    descripcion = models.TextField()

class CotizacionAccesorios(models.Model):
    id_cotizacion = models.OneToOneField(Cotizacion, on_delete=models.CASCADE, primary_key=True)
    id_accesorio = models.ForeignKey(Accesorios, on_delete=models.CASCADE)