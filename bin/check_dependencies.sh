#!/bin/bash

echo "Check corepack"
corepack --version || (echo "corepack is not installed. Please run `make install`" && exit 1)
echo "Check node"
node --version || (echo "node is not installed. Please run `make install`" && exit 1)
echo "Check pnpm"
pnpm --version || (echo "pnpm is not installed. Please run `make install`" && exit 1)
echo "Check hugo"
hugo version || (echo "hugo is not installed. Please run `make install`" && exit 1)
echo "Check uv"
uv --version || (echo "uv is not installed. Please run `make install`" && exit 1)
echo "Check pre-commit"
pre-commit --version || (echo "pre-commit is not installed. Please run `make install`" && exit 1)
echo "Check git flow"
git flow version || (echo "git flow is not installed. Please run `make install`" && exit 1)
echo "All dependencies are installed."
