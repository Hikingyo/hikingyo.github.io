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

# Configurer git flow
git config init.defaultBranch master
git config gitflow.branch.master master
git config gitflow.branch.develop develop
git config gitflow.prefix.feature feature/
git config gitflow.prefix.release release/
git config gitflow.prefix.hotfix hotfix/
git config gitflow.prefix.support support/
git config gitflow.prefix.versiontag
git config gitflow.path.hooks .git/hooks
