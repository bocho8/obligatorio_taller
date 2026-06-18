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

echo "Cambios detectados:"
echo "$CAMBIOS"

LINEAS=$(git diff --shortstat | tr -d '\n')
echo "Resumen: $LINEAS"

git add -A
git reset README.md
git commit -m "Sincronización semanal - $FECHA"

if git push origin "$RAMA"; then
    echo "Push exitoso."
    echo "- [$FECHA] [EXITO] Push en $RAMA. $LINEAS" >> README.md
    git add README.md
    git commit -m "Log: push exitoso - $FECHA"
    git push origin "$RAMA"
    exit 0
else
    echo "ERROR: Falló el push."
    echo "- [$FECHA] [ERROR] Falló push en $RAMA" >> README.md
    git add README.md
    git commit -m "Log: push fallido - $FECHA"
    git push origin "$RAMA" || echo "AVISO: No se pudo pushear el log de error."
    exit 1
fi
