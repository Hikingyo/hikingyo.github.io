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

# Download and install pnpm if not already installed using corepack (which comes with Node.js):
corepack enable
corepack prepare pnpm@latest --activate

# Verify pnpm version:
pnpm -v

# Install project dependencies using pnpm:
pnpm install

# Installer git flow if needed
if ! command -v git-flow &> /dev/null
then
    echo "git-flow could not be found, installing..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install git-flow -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install git-flow-avh
    else
        echo "Unsupported OS. Please install git-flow manually."
        exit 1
    fi
else
    echo "git-flow is already installed."
fi

# check git flow configuration
if git config --get gitflow.branch.master &> /dev/null; then
    echo "git flow is already configured."
    git config --get-regexp 'gitflow.*'
else
    echo "git flow is not configured yet."
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
fi

# Installing pre-commit if needed
if ! command -v pre-commit &> /dev/null
then
    echo "pre-commit could not be found, installing..."
    uv tool install pre-commit;
fi

echo "Installing hooks..."
pre-commit install --install-hooks;
