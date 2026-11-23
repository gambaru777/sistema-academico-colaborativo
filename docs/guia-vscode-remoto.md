# Subir el proyecto a GitHub desde VS Code (remoto)

"Remoto" = el repositorio en GitHub (`origin`). Todo se hace desde la terminal integrada de VS Code (`Ctrl+ñ`).
Para Windows usa **Git Bash** como terminal (menú del `+` de la terminal → Git Bash).

## 1. Antes de empezar
1. Instala Git, Python 3.10+ y VS Code.
2. En VS Code: icono de cuenta (abajo a la izquierda) → **Iniciar sesión con GitHub**. Así no escribes contraseñas ni tokens.
3. Abre esta carpeta: **Archivo → Abrir carpeta**.
4. Verifica y configura (evidencia 1 y 2):
```bash
git --version
python --version
git config --global user.name "Tu Nombre"
git config --global user.email "tu-correo@example.com"
git config --global --list
```

## 2. Crear el repositorio remoto
En github.com: **New repository** → nombre `sistema-academico-colaborativo`, **sin** README ni .gitignore. Copia la URL HTTPS.
Añade a los otros 2 integrantes en **Settings → Collaborators**.

## 3. Subir main y dev
```bash
bash scripts/flujo_git.sh init https://github.com/TU_USUARIO/sistema-academico-colaborativo.git
```
(Reemplaza la URL por la tuya.) VS Code pedirá autorizar GitHub la primera vez.

## 4. Issues (en GitHub → Issues → New issue)
Crea los 5 de `docs/guia-issues.md`, con responsable y etiquetas. Los números los asigna GitHub.

## 5. Ramas, commits y Pull Requests
Cada integrante toma una rama:
```bash
bash scripts/flujo_git.sh registro     # Integrante 1
# -> en GitHub: Pull Request feature/registro-estudiantes -> dev, pedir revisión, fusionar
bash scripts/flujo_git.sh listado      # Integrante 2, DESPUÉS de fusionar el PR anterior
bash scripts/flujo_git.sh docs         # Integrante 3
```
En cada PR: usa la plantilla, escribe `Closes #N` (N = número real del Issue), pide revisión a otro integrante y fusiona solo después de que revise.
Para `main`: cuando `dev` esté estable, abre un PR `dev -> main`.

## 6. Conflicto (docs/guia-conflictos.md)
Sigue esa guía en un repositorio de prueba o con todo confirmado. Guarda capturas del conflicto, la resolución y `git log --oneline --graph --all`.

## 7. Evidencias finales
```bash
git branch -a
git log --oneline --graph --decorate --all
python -m unittest discover -s tests -v
git status
```
Completa `docs/evidencias.md` y `docs/informe-final.md` con **tus datos reales** (URL, nº de ramas, PRs, resultado de pruebas).

## Si algo falla
- `rejected` al hacer push: `git pull --rebase origin NOMBRE_RAMA` solo si entiendes el estado; si dudas, pide revisión.
- `remote origin already exists`: `git remote set-url origin URL_CORRECTA`.
- Pide autenticación en bucle: cierra sesión y vuelve a iniciar sesión con GitHub en VS Code.
