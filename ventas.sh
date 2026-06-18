#!/bin/bash

ARCHIVO_BD="data/ventas.dat"
usuario_logueado=""

registrar_usuario() {
    echo "=== REGISTRO DE USUARIO ==="
    read -p "Ingrese nombre de usuario: " nombre
    if [[ -z "$nombre" ]]; then
        echo "Error: El usuario no puede estar vacío."
        return 1
    fi
    if [[ "$nombre" =~ [[:space:]] ]]; then
        echo "Error: El nombre no puede contener espacios."
        return 1
    fi

    mkdir -p data
    touch "$ARCHIVO_BD"
    if grep -q "^USUARIO:$nombre " "$ARCHIVO_BD"; then
        echo "Error: El usuario '$nombre' ya existe."
        return 1
    fi

    read -s -p "Ingrese contraseña: " clave
    echo ""
    if [[ -z "$clave" ]]; then
        echo "Error: La contraseña no puede estar vacía."
        return 1
    fi
    if [[ "$clave" =~ [[:space:]] ]]; then
        echo "Error: La contraseña no puede contener espacios."
        return 1
    fi

    echo "USUARIO:$nombre $clave" >> "$ARCHIVO_BD"
    echo "Usuario '$nombre' registrado correctamente."
}

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
        echo "2) Iniciar sesión"
        echo "3) Alta de producto"
        echo "4) Comprar producto"
        echo "5) Cerrar sesión"
        echo "6) Salir"
        echo "====================================="
        read -p "Seleccione una opción (1-6): " opcion

        case "$opcion" in
            1) registrar_usuario ;;
            2) echo "iniciar sesion" ;;
            3) echo "alta producto" ;;
            4) echo "comprar producto" ;;
            5) echo "cerrar sesion" ;;
            6) echo "Saliendo..." && exit 0 ;;
            *) echo "Opción inválida. Intente de nuevo." ;;
        esac
    done
}

menu
