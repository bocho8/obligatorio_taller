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
else
    echo "Cambios detectados."
    echo "$CAMBIOS"
fi
