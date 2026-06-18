#!/bin/bash

cd $(dirname "$0")/..
RAMA=$(git branch --show-current)
FECHA=$(date '+%Y-%m-%d %H:%M:%S')

echo "Rama actual: $RAMA"
echo ""

git pull origin "$RAMA"

CAMBIOS=$(git status --porcelain)
if [[ -z "$CAMBIOS" ]]; then
    echo "ALERTA: No hay cambios locales para subir."
    echo "- [$FECHA] [ALERTA] Sin cambios en $RAMA" >> README.md
    exit 1
fi

LINEAS=$(git diff --shortstat | tr -d '\n')
echo "Resumen: $LINEAS"

git add -A
git commit -m "Sincronización semanal - $FECHA"

if git push origin "$RAMA"; then
    echo "Push exitoso."
    echo "- [$FECHA] [EXITO] Push en $RAMA. $LINEAS" >> README.md
    exit 0
else
    echo "ERROR: Falló el push."
    echo "- [$FECHA] [ERROR] Falló push en $RAMA" >> README.md
    exit 1
fi
