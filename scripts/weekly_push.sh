#!/bin/bash
#
#   Autores: Fabrizio Pedemonti - N° 372959
#            Lucas Pittaluga      - N° 372926
#            Agustin Roizen       - N° 350021
#
# Script de sincronización semanal que ejecuta el cron.
#
# Flujo:
#   1. Se para en la raíz del repo y hace pull
#   2. Revisa si hay cambios locales (git status --porcelain)
#      - Si NO hay cambios: escribe alerta en README y la pushea
#      - Si hay cambios: commitea todo (menos README), pushea,
#        y después escribe el resultado en README
#
# La decisión de separar README del commit principal:
#   Si escribís el resultado en README antes de pushear y el push falla,
#   queda un registro falso de éxito. Por eso se hace:
#     1. git add -A
#     2. git reset README.md   (saca README del commit)
#     3. commit y push de los cambios reales
#     4. Según el resultado del push, se escribe en README y se commitea aparte

cd $(dirname "$0")/..
RAMA=$(git branch --show-current)
FECHA=$(date '+%Y-%m-%d %H:%M:%S')

echo "Rama actual: $RAMA"
echo ""

git pull origin "$RAMA"

# --porcelain devuelve vacío si no hay nada para commitear
CAMBIOS=$(git status --porcelain)
if [[ -z "$CAMBIOS" ]]; then
    echo "ALERTA: No hay cambios locales para subir."

    # Escribe el registro de alerta directamente en README
    echo "- [$FECHA] [ALERTA] Sin cambios en $RAMA" >> README.md
    git add README.md
    git commit -m "Log: registro de alerta semanal"

    if git push origin "$RAMA"; then
        echo "Push de alerta exitoso."
        exit 0
    else
        echo "ERROR: Falló el push de alerta."
        exit 1
    fi
fi

# Si llegó acá, hay cambios locales
echo "Cambios detectados:"
echo "$CAMBIOS"

# --shortstat da un resumen tipo "3 files changed, 20 insertions(+), 5 deletions(-)"
LINEAS=$(git diff --shortstat | tr -d '\n')
echo "Resumen: $LINEAS"

# Stagea todo, pero saca README para no mezclar el log con los cambios reales
git add -A
git reset README.md
git commit -m "Sincronización semanal - $FECHA"

if git push origin "$RAMA"; then
    echo "Push exitoso."
    # Solo ahora que sabemos que el push funcionó, escribimos EXITO en README
    echo "- [$FECHA] [EXITO] Push en $RAMA. $LINEAS" >> README.md
    git add README.md
    git commit -m "Log: push exitoso - $FECHA"
    git push origin "$RAMA"
    exit 0
else
    echo "ERROR: Falló el push."
    # Si falló, registramos ERROR. Si este push también falla, mostramos aviso
    # pero no cortamos con error (ya falló el principal, no empeorar)
    echo "- [$FECHA] [ERROR] Falló push en $RAMA" >> README.md
    git add README.md
    git commit -m "Log: push fallido - $FECHA"
    git push origin "$RAMA" || echo "AVISO: No se pudo pushear el log de error."
    exit 1
fi
