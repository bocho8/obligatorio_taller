# Bitácora — Desafío 18

## KAN-10: Inicializar repo y GitFlow

El repo de GitHub tenía branches viejas (develop, old_main) y un tag del intento anterior. Se borraron con `git push origin --delete develop`, `git push origin --delete tag v1.0.0`, y `git branch -D old_main` local.

Ramas creadas desde main limpio:
- `develop` — integración
- `feature/autenticacion` — registro y login
- `feature/alta-productos` — ABM productos
- `feature/venta-productos` — compras

Todas subidas a GitHub y ya se ven con `git branch -a`.
