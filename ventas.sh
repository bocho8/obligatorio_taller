#!/bin/bash
#
#   Autores: Fabrizio Pedemonti - N° 372959
#            Lucas Pittaluga      - N° 372926
#            Agustin Roizen       - N° 350021
#
# Sistema de ventas en Bash con archivo de texto como base de datos.
# Guarda usuarios, productos y ventas en data/ventas.dat.
#
# Formato del archivo (una línea por registro):
#   USUARIO:nombre clave
#   PRODUCTO:nombre descripcion precio stock
#   VENTA:usuario nombre_producto cantidad
#
# La sesión se maneja con la variable global usuario_logueado.
# Si está vacía, el usuario no inició sesión.

ARCHIVO_BD="data/ventas.dat"
usuario_logueado=""

# ==================== USUARIOS ====================
# Registro, inicio y cierre de sesión.
# Las contraseñas se guardan en texto plano (el obligatorio no pide hash).
# No se puede registrar dos usuarios con el mismo nombre.

registrar_usuario() {
    echo "=== REGISTRO DE USUARIO ==="

    # Nombre: no vacío, sin espacios, sin duplicados
    read -p "Ingrese nombre de usuario: " nombre
    if [[ -z "$nombre" ]]; then
        echo "Error: El usuario no puede estar vacio."
        return 1
    fi
    if [[ "$nombre" =~ [[:space:]] ]]; then
        echo "Error: El nombre no puede contener espacios."
        return 1
    fi

    mkdir -p data
    touch "$ARCHIVO_BD"
    # grep -q busca coincidencia exacta al principio de línea
    if grep -q "^USUARIO:$nombre " "$ARCHIVO_BD"; then
        echo "Error: El usuario '$nombre' ya existe."
        return 1
    fi

    # Contraseña: oculta con -s, mismas validaciones que el nombre
    read -s -p "Ingrese contrasena: " clave
    echo ""
    if [[ -z "$clave" ]]; then
        echo "Error: La contrasena no puede estar vacia."
        return 1
    fi
    if [[ "$clave" =~ [[:space:]] ]]; then
        echo "Error: La contrasena no puede contener espacios."
        return 1
    fi

    echo "USUARIO:$nombre $clave" >> "$ARCHIVO_BD"
    echo "Usuario '$nombre' registrado correctamente."
}

iniciar_sesion() {
    # Si ya hay sesión activa, no deja iniciar otra
    if [[ -n "$usuario_logueado" ]]; then
        echo "Ya hay una sesion activa como '$usuario_logueado'."
        return 0
    fi

    echo "=== INICIAR SESION ==="
    read -p "Usuario: " nombre_usuario
    read -s -p "Contrasena: " clave
    echo ""

    if [[ -z "$nombre_usuario" || -z "$clave" ]]; then
        echo "Error: Usuario y contrasena no pueden estar vacios."
        return 1
    fi

    # grep con $ al final: la línea debe terminar exactamente con la clave
    # (evita que "pass" matchee "password")
    if grep -q "^USUARIO:$nombre_usuario $clave$" "$ARCHIVO_BD"; then
        usuario_logueado="$nombre_usuario"
        echo "Bienvenido, $usuario_logueado."
    else
        echo "Error: Usuario o contrasena incorrectos."
    fi
}

cerrar_sesion() {
    if [[ -z "$usuario_logueado" ]]; then
        echo "No hay ninguna sesion activa."
        return 1
    fi
    echo "Cerrando sesion de '$usuario_logueado'..."
    usuario_logueado=""
    echo "Sesion cerrada."
}

# ==================== PRODUCTOS ====================
# Alta y compra de productos.
# Para comprar hay que estar logueado.
# El stock se actualiza con un archivo temporal (no se edita in-place).

alta_producto() {
    if [[ -z "$usuario_logueado" ]]; then
        echo "Error: Debe iniciar sesion para dar de alta un producto."
        return 1
    fi

    echo "=== ALTA DE PRODUCTO ==="

    # Nombre: mismas validaciones que usuarios
    read -p "Nombre del producto: " nombre
    if [[ -z "$nombre" ]]; then
        echo "Error: El nombre no puede estar vacio."
        return 1
    fi
    if [[ "$nombre" =~ [[:space:]] ]]; then
        echo "Error: El nombre no puede contener espacios."
        return 1
    fi

    if grep -q "^PRODUCTO:$nombre " "$ARCHIVO_BD"; then
        echo "Error: El producto '$nombre' ya existe."
        return 1
    fi

    read -p "Descripcion: " descripcion
    # Reemplaza espacios por guiones bajos para que quede como un solo campo
    descripcion=${descripcion// /_}

    # Precio: entero positivo, loop hasta que pongan uno válido
    while true; do
        read -p "Precio: " precio
        if [[ "$precio" =~ ^[0-9]+$ ]] && [[ "$precio" -gt 0 ]]; then
            break
        fi
        echo "Error: Debe ser un numero entero positivo."
    done

    # Stock: entero >= 0 (se puede crear con stock cero)
    while true; do
        read -p "Stock: " stock
        if [[ "$stock" =~ ^[0-9]+$ ]] && [[ "$stock" -ge 0 ]]; then
            break
        fi
        echo "Error: Debe ser un numero entero no negativo."
    done

    echo "PRODUCTO:$nombre $descripcion $precio $stock" >> "$ARCHIVO_BD"
    echo "Producto '$nombre' registrado con stock $stock."
}

comprar_producto() {
    if [[ -z "$usuario_logueado" ]]; then
        echo "Error: Debe iniciar sesion para comprar."
        return 1
    fi

    echo "=== COMPRAR PRODUCTO ==="
    read -p "Nombre del producto: " nombre

    # Busca la línea del producto. Si no existe, error.
    linea=$(grep "^PRODUCTO:$nombre " "$ARCHIVO_BD")
    if [[ -z "$linea" ]]; then
        echo "Error: El producto '$nombre' no existe."
        return 1
    fi

    # Extrae los campos de la línea (descripción puede tener guiones bajos)
    datos=${linea#PRODUCTO:}
    read -r prod_nombre prod_desc prod_precio prod_stock <<< "$datos"

    # Cantidad: entero positivo (no cero, no negativo, no letras)
    read -p "Cantidad: " cantidad
    if ! [[ "$cantidad" =~ ^[0-9]+$ ]] || [[ "$cantidad" -eq 0 ]]; then
        echo "Error: La cantidad debe ser un entero mayor a cero."
        return 1
    fi

    if [[ "$cantidad" -gt "$prod_stock" ]]; then
        echo "Error: Stock insuficiente. Disponible: $prod_stock."
        return 1
    fi

    nuevo_stock=$((prod_stock - cantidad))
    # Registra la venta como una línea nueva
    echo "VENTA:$usuario_logueado $nombre $cantidad" >> "$ARCHIVO_BD"

    # Actualiza el stock: lee línea por línea, reescribe solo la del producto
    # Se usa un archivo temporal porque no se puede editar in-place en Bash
    temp=$(mktemp)
    while IFS= read -r linea_bd; do
        if [[ "$linea_bd" == "PRODUCTO:$nombre "* ]]; then
            echo "PRODUCTO:$prod_nombre $prod_desc $prod_precio $nuevo_stock" >> "$temp"
        else
            echo "$linea_bd" >> "$temp"
        fi
    done < "$ARCHIVO_BD"
    mv "$temp" "$ARCHIVO_BD"

    echo "Compra realizada: $cantidad unidad(es) de '$nombre'."
    echo "Stock restante: $nuevo_stock."
}

# ==================== MENU ====================
# Loop infinito que muestra las opciones y despacha a cada función.
# Sale solo con la opción 6 (exit 0).

menu() {
    while true; do
        echo ""
        echo "====================================="
        echo "   SISTEMA DE VENTAS - NoInternet Co"
        echo "====================================="
        if [[ -z "$usuario_logueado" ]]; then
            echo "   [Estado: No logueado]"
        else
            echo "   [Estado: Logueado como '$usuario_logueado']"
        fi
        echo "====================================="
        echo "1) Registrar usuario"
        echo "2) Iniciar sesion"
        echo "3) Alta de producto"
        echo "4) Comprar producto"
        echo "5) Cerrar sesion"
        echo "6) Salir"
        echo "====================================="
        read -p "Seleccione una opcion (1-6): " opcion

        case "$opcion" in
            1) registrar_usuario ;;
            2) iniciar_sesion ;;
            3) alta_producto ;;
            4) comprar_producto ;;
            5) cerrar_sesion ;;
            6) echo "Saliendo..." && exit 0 ;;
            *) echo "Opcion invalida. Intente de nuevo." ;;
        esac
    done
}

menu
