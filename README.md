# 🧠 Blog — Hugo + Go + PNPM

[![Theme Update](https://github.com/Hikingyo/blog/actions/workflows/theme-update.yml/badge.svg)](https://github.com/Hikingyo/blog/actions/workflows/theme-update.yml)
[![Deploy to GitHub Pages](https://github.com/Hikingyo/blog/actions/workflows/deploy-site.yml/badge.svg)](https://github.com/Hikingyo/blog/actions/workflows/deploy-site.yml)

Site statique propulsé par [Hugo](https://gohugo.io/) et géré avec Go Modules + PNPM.
Déploiement automatisé via GitHub Actions sur la branche `gh-pages`.

> 📜 Licence [Beerware](./LICENSE.md) — tu kiffes ? Paye une bière 🍺

---

## 🚀 Stack technique

- [Hugo Extended](https://gohugo.io/) — géré via Go Modules
- [Go 1.24+](https://go.dev/dl/)
- [Node.js 23](https://nodejs.org)
- [pnpm](https://pnpm.io/) (v10+)
- GitHub Actions pour update + déploiement
- `pre-commit` hooks
- `Makefile` : commandes locales de dev

---

## 🧰 Installation rapide

```bash
make install
```


---

## 📦 Dépendances

```bash
hugo mod get -u
pnpm install
```

Les polices sont injectées dynamiquement à chaque build via :

```bash
pnpm add -D @fontsource/fira-code @fontsource/ibm-plex-serif
```

(*remplacées à chaque `hugo mod npm pack` — c’est volontaire.*)

---

## ⚙️ Commandes `make`

Run `make` to see all available commands.

---

## 🤖 Workflows CI/CD

### 🎨 Mise à jour automatique

`.github/workflows/theme-update.yml`
→ Met à jour Hugo modules + dépendances NPM, puis ouvre une PR si besoin.

### 🚀 Déploiement continu

`.github/workflows/deploy-site.yml`
→ Déploiement automatique sur `gh-pages` à chaque merge dans `master` via [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages)

---

## 🧪 Développement local

```bash
hugo server
```

Accessible sur `http://localhost:1313`

---

## 🙌 Crédits

- [Hikingyo](https://github.com/Hikingyo) — forge, sueur, structure
- [Toha Theme](https://github.com/hugo-toha/toha) — base stylée et fonctionnelle
- [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages) — déploiement sans douleur
