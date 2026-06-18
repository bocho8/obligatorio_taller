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

## KAN-5: Registro de usuarios

Funcion registrar_usuario() agregada a ventas.sh. Valida nombre vacio, espacios, duplicados, y contrasena. Guarda en data/ventas.dat con formato USUARIO:nombre clave.
