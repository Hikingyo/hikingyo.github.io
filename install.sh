#!/bin/bash

set -e

# 🔍 Détection OS et archi
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="64bit" ;;
  arm64|aarch64) ARCH="ARM64" ;;
  *) echo "Archi non supportée : $ARCH" && exit 1 ;;
esac

# 📦 Version de Hugo (tu peux en fixer une si tu veux)
VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | grep tag_name | cut -d '"' -f 4)
FILENAME="hugo_extended_${VERSION#v}_${OS}-${ARCH}.tar.gz"
URL="https://github.com/gohugoio/hugo/releases/download/${VERSION}/${FILENAME}"

echo "🔽 Téléchargement de Hugo Extended $VERSION pour $OS-$ARCH..."
curl -L -o "$FILENAME" "$URL"

echo "📦 Extraction..."
tar -xzf "$FILENAME"

echo "🧹 Suppression ancienne version Go install (si elle existe)..."
rm -f ~/go/bin/hugo

echo "📂 Installation dans /usr/local/bin (peut demander le mot de passe)"
sudo mv hugo /usr/local/bin/hugo

echo "🧼 Nettoyage..."
rm -f "$FILENAME" LICENSE README.md

echo "✅ Hugo installé :"
hugo version

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 23

# Verify the Node.js version:
node -v # Should print "v23.10.0".
nvm current # Should print "v23.10.0".

# Download and install pnpm:
corepack enable pnpm

# Verify pnpm version:
pnpm -v
