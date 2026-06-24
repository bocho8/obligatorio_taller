# Bitácora — Desafío 18

## KAN-10: Inicializar repo y GitFlow

El repo de GitHub tenía branches viejas (develop, old_main) y un tag del intento anterior. Se borraron con `git push origin --delete develop`, `git push origin --delete tag v1.0.0`, y `git branch -D old_main` local.

Ramas creadas desde main limpio:
- `develop` — integración
- `feature/autenticacion` — registro y login
- `feature/alta-productos` — ABM productos
- `feature/venta-productos` — compras

Todas subidas a GitHub y ya se ven con `git branch -a`.

## KAN-11: Script de detección de cambios

Se creó `scripts/weekly_push.sh` con `git pull`, `git status --porcelain`, y alerta si no hay cambios. En la primera ejecución detectó correctamente `scripts/` como untracked. Pendiente KAN-12 para commit + push.

## KAN-12: Script de commit y push

Se completó `scripts/weekly_push.sh`. El problema principal: no se puede escribir `[EXITO]` en README antes del push porque si el push falla queda un falso positivo. La solución fue separar README del commit grande con `git add -A && git reset README.md` y escribir el registro solo después de confirmar el resultado del push.

## KAN-4: Menú interactivo

Se creó `ventas.sh` con la estructura base: shebang, variables `ARCHIVO_BD` y `usuario_logueado`, función `menu()` con `while true`, `case` y `read` para 6 opciones.

## KAN-5: Registro de usuarios

Funcion registrar_usuario() agregada a ventas.sh. Valida nombre vacio, espacios, duplicados, y contrasena. Guarda en data/ventas.dat con formato USUARIO:nombre clave. Se ignoro data/ con .gitignore.

## Problemas

- **Merge conflict en docs/bitacora.md**: main y develop tenian la entrada de KAN-5 redactada distinto. Se resolvio quedandose con la version mas completa (main) y unificando el formato.
- **Branches desincronizadas**: los commits de scripts y docs se hicieron en main, no en develop. Solucion: merge main → develop y develop → feature/* en cadena.
- **git diff --shortstat vacio**: cuando no hay commits nuevos en la rama, diff no devuelve nada. Solucion: verificar con un if que la variable no este vacia antes de usarla (se resolvio en KAN-12).

## KAN-16: Template Bug

Se creo .github/ISSUE_TEMPLATE/bug.yml con campos: descripcion, pasos para reproducir y comportamiento esperado.

## KAN-17: Template Feature Request

Se creo .github/ISSUE_TEMPLATE/feature_request.yml con campos: problema relacionado, solucion propuesta y alternativas consideradas.

## KAN-18 a KAN-21: Templates restantes y README

Lucas creo los templates de Mejora y Documentacion, y completo el README.md del repositorio.

## Post-auditoria: Correcciones

Se integro el codigo de Fabri (alta de productos, inicio/cierre de sesion, compra de productos) al ventas.sh unificado usando el formato ARCHIVO_BD. Se mergeo main a develop para sincronizar templates y docs. Se borro la rama Alta-de-productos (mal nombrada) y se reabrieron los 8 issues de ejemplo en GitHub.
