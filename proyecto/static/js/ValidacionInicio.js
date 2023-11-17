// Archivo: validacion.js para los campos de registro de inicio de seccion 

function validarUsuario() {
    var usuario = document.getElementById("usuario").value;
    var contrasena = document.getElementById("contrasena").value;

    // Validar usuarios y contraseñas
    if (usuario === "usuario1" && contrasena === "contrasena1") {
        window.location.href = "/formularios/EdicionEmpleados.html";
    } else if (usuario === "usuario2" && contrasena === "contrasena2") {
        window.location.href = "/formularios/EdicionEmpleados2.html";
    } else if (usuario === "usuario3" && contrasena === "contrasena3") {
        window.location.href = "/formularios/EdicionEmpleados3.html";
    } else {
        alert("Usuario o contraseña incorrectos. Inténtalo de nuevo.");
    }
}



