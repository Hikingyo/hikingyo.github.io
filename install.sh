#!/bin/bash

set -e

# 📦 Version de Hugo (tu peux en fixer une si tu veux)
CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest

echo "🧼 Nettoyage..."
rm -f "$FILENAME" LICENSE README.md

echo "✅ Hugo installé :"
hugo version

hogu mod tidy

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# instead of restarting the shell
source "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 23

# Verify the Node.js version:
node -v # Should print "v23.10.0".
nvm current # Should print "v23.10.0".

# Download and install pnpm:
corepack enable pnpm

# Verify pnpm version:
pnpm -v

pnpm install
