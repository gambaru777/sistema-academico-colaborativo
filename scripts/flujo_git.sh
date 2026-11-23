#!/usr/bin/env bash
# Automatiza las fases de docs/guia-ejecucion.md. Ejecutar desde la RAÍZ del proyecto
# en la terminal de VS Code (Git Bash, WSL o Linux/Mac).
#
# Uso:
#   bash scripts/flujo_git.sh init URL_DEL_REPOSITORIO   # Fases 2 y 3: main + dev
#   bash scripts/flujo_git.sh registro                   # Fase 4: feature/registro-estudiantes
#   bash scripts/flujo_git.sh listado                    # feature/listado-estudiantes (tras fusionar el PR de registro)
#   bash scripts/flujo_git.sh docs                       # docs/guia-proyecto
#
# Los Pull Requests, la revisión y la fusión se hacen en GitHub (otro integrante revisa).
set -euo pipefail

paso() { echo; echo ">>> $*"; }
pruebas() {
  PY=python; command -v python >/dev/null 2>&1 || PY=python3
  command -v "$PY" >/dev/null 2>&1 || PY="py"
  "$PY" -m unittest discover -s tests -v
}

if [ -z "$(git config user.name || true)" ] || [ -z "$(git config user.email || true)" ]; then
  echo "Falta configurar tu identidad. Ejecuta primero:"
  echo '  git config --global user.name "Tu Nombre"'
  echo '  git config --global user.email "tu-correo@example.com"'
  exit 1
fi

case "${1:-}" in
  init)
    URL="${2:-}"; [ -n "$URL" ] || { echo "Falta la URL del repositorio."; exit 1; }
    paso "Fase 2: commit inicial en main (estructura, .gitignore, README, plantillas)"
    [ -d .git ] || git init
    git branch -M main
    git add .gitignore README.md .github docs scripts
    git commit -m "chore: crea estructura inicial del proyecto"
    git remote add origin "$URL" 2>/dev/null || git remote set-url origin "$URL"
    git push -u origin main
    paso "Fase 3: rama de integración dev"
    git switch -c dev
    git push -u origin dev
    ;;
  registro)
    paso "Fase 4: feature/registro-estudiantes"
    git switch dev && git pull origin dev
    git switch -c feature/registro-estudiantes
    pruebas
    git add src/__init__.py src/estudiantes.py
    git commit -m "feat: implementa registro de estudiantes"
    git add tests/test_estudiantes.py
    git commit -m "test: agrega pruebas de validacion y orden"
    git push -u origin feature/registro-estudiantes
    echo "Ahora abre el Pull Request hacia dev en GitHub y pide revisión."
    ;;
  listado)
    paso "feature/listado-estudiantes (requiere que el PR de registro ya esté fusionado en dev)"
    git switch dev && git pull origin dev
    git switch -c feature/listado-estudiantes
    pruebas
    git add src/main.py
    git commit -m "feat: agrega menu y listado de estudiantes"
    git push -u origin feature/listado-estudiantes
    echo "Abre el Pull Request hacia dev en GitHub y pide revisión."
    ;;
  docs)
    paso "docs/guia-proyecto"
    git switch dev && git pull origin dev
    git switch -c docs/guia-proyecto
    echo "- Última revisión de la guía: $(date +%F)" >> docs/evidencias.md
    git add docs/evidencias.md
    git commit -m "docs: actualiza lista de evidencias"
    git push -u origin docs/guia-proyecto
    echo "Abre el Pull Request hacia dev en GitHub y pide revisión."
    ;;
  *)
    sed -n '2,12p' "$0"; exit 1;;
esac

paso "Verificación"
git branch -a
git log --oneline --graph --decorate --all
git status
