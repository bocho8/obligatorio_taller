#!/bin/bash

ARCHIVO_BD="data/ventas.dat"
usuario_logueado=""

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
            1) echo "registrar usuario" ;;
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
