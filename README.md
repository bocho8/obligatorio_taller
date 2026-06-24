# Sistema de Ventas - Taller de Tecnologías

## Descripción del proyecto

Este proyecto es un sistema de ventas en Bash con Git y GitHub. Permite administrar usuarios, productos y ventas, siguiendo GitFlow para el control de versiones.

## Integrantes

* Lucas Pittaluga
* Fabrizio Peedemonti
* Agustin Roizen

## Requisitos

Necesitás:

* Linux o Git Bash en Windows.
* Git instalado.
* Bash.
* Una cuenta de GitHub.

## Instrucciones de uso

1. Clonar el repositorio:

```bash
git clone https://github.com/bocho8/obligatorio_taller.git
```

2. Ingresar al directorio:

```bash
cd obligatorio_taller
```

3. Dar permisos de ejecución:

```bash
chmod +x ventas.sh
```

4. Ejecutar el sistema:

```bash
./ventas.sh
```

## GitFlow utilizado

Ramas principales:

* main: versión estable.
* develop: integración de funcionalidades.

Ramas de funcionalidades:

* feature/autenticacion
* feature/alta-productos
* feature/venta-productos

Diagrama:

main
└── develop
    ├── feature/autenticacion
    ├── feature/alta-productos
    └── feature/venta-productos

## Gestión de Issues

Creamos 4 templates de GitHub Issues:

* Bugs
* Feature Requests
* Mejoras
* Documentación

## Enlaces a Issues

* Bug #8 — [Iniciar sesión con usuario vacío](https://github.com/bocho8/obligatorio_taller/issues/8)
* Bug #7 — [Cantidad de compra no numérica rompe stock](https://github.com/bocho8/obligatorio_taller/issues/7)
* Feature Request #6 — [Historial de compras por usuario](https://github.com/bocho8/obligatorio_taller/issues/6)
* Feature Request #5 — [Exportar ventas a CSV](https://github.com/bocho8/obligatorio_taller/issues/5)
* Mejora #4 — [Listar productos antes de comprar](https://github.com/bocho8/obligatorio_taller/issues/4)
* Mejora #3 — [Validar precio negativo en alta](https://github.com/bocho8/obligatorio_taller/issues/3)
* Documentación #2 — [Falta diagrama Gitflow](https://github.com/bocho8/obligatorio_taller/issues/2)
* Documentación #1 — [README sin permisos de data/](https://github.com/bocho8/obligatorio_taller/issues/1)

## Bitácora de sincronización

Registros generados por `scripts/weekly_push.sh` con la actividad semanal del repositorio:

- [2026-06-23 22:00:00] [EXITO] Push en main. 3 files changed, 20 insertions(+), 5 deletions(-)

