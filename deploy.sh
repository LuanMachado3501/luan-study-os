#!/bin/bash
# deploy.sh — sobe o projeto para GitHub Pages
# USO: bash deploy.sh <seu-usuario-github>
# Ex:  bash deploy.sh luanparaisopolis

set -e

GITHUB_USER="${1:-SEU_USUARIO}"
REPO="luan-study-os"
BRANCH="gh-pages"

echo "╔══════════════════════════════════════╗"
echo "║  luan-study-os — GitHub Pages Deploy ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Verifica se git está configurado
if ! git config user.email > /dev/null 2>&1; then
  echo "⚠  Configure o git primeiro:"
  echo "   git config --global user.email 'seu@email.com'"
  echo "   git config --global user.name 'Seu Nome'"
  exit 1
fi

# Verifica se PDFs existem
if [ ! -d "pdfs" ] || [ -z "$(ls pdfs/*.pdf 2>/dev/null)" ]; then
  echo "⚠  Pasta pdfs/ vazia. Rode primeiro:"
  echo "   python3 scripts/prepare_pdfs.py --src /caminho/dos/pdfs"
  exit 1
fi

echo "✓  PDFs encontrados:"
ls pdfs/*.pdf | while read f; do
  size=$(du -sh "$f" | cut -f1)
  echo "   $f ($size)"
done
echo ""

# Inicializa git se necessário
if [ ! -d ".git" ]; then
  git init
  git remote add origin "https://github.com/${GITHUB_USER}/${REPO}.git"
  echo "✓  Git inicializado"
fi

# Cria .gitattributes para LFS nos PDFs grandes (opcional)
cat > .gitattributes << 'ATTR'
*.pdf filter=lfs diff=lfs merge=lfs -text
ATTR

# Verifica se GitHub CLI está disponível para criar o repo
if command -v gh &> /dev/null; then
  echo "Criando repositório no GitHub..."
  gh repo create "${GITHUB_USER}/${REPO}" --public --source=. --remote=origin 2>/dev/null || true
else
  echo "⚠  GitHub CLI não encontrado."
  echo "   Crie o repositório manualmente em: https://github.com/new"
  echo "   Nome: ${REPO} | Público | Sem README"
  echo ""
  echo "   Depois rode:"
  echo "   git remote add origin https://github.com/${GITHUB_USER}/${REPO}.git"
  read -p "   Pressione Enter quando o repositório estiver criado..."
fi

# Commit e push
echo ""
echo "Fazendo commit e push..."
git checkout -B ${BRANCH}
git add -A
git commit -m "deploy: FME Iezzi viewer + Study OS $(date '+%Y-%m-%d %H:%M')"
git push -u origin ${BRANCH} --force

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  Deploy concluído!                                    ║"
echo "║                                                       ║"
echo "║  URL base:                                            ║"
echo "║  https://${GITHUB_USER}.github.io/${REPO}/           ║"
echo "║                                                       ║"
echo "║  ⚠  GitHub Pages pode demorar 1-2min para ativar    ║"
echo "║  Vá em Settings → Pages → Branch: gh-pages           ║"
echo "╚══════════════════════════════════════════════════════╝"
