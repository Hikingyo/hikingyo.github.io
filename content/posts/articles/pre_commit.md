---
title: "Pre-commit, pour des MR bien léchées"
date: "2025-09-07T16:10:00"
hero: "/images/posts/articles/pre_commit_workflow.webp"
tags: ["git", "outils", "CI/CD", "qualité"]
categories: ["outils", "CI/CD", "qualité"]
author: "火金魚"
draft: false
menu:
    sidebar:
        name: Pre-commit
        identifier: articles-pre-commit
        parent: articles
        weight: 5
---

## De l’art de la review zen

Combien d’heures se perdent en *merge requests* sur des broutilles ?
Espaces en trop. Imports mal triés. Fichiers oubliés.
Ou pire : un secret API balancé par erreur dans l’historique.

Ce temps est précieux. C’est du temps d’ingénieurs, du temps de reviewers — et beaucoup de frustration.

Avant de plonger dans `pre-commit`, rappel express sur les hooks Git.
Ce sont de simples scripts qui s’exécutent à différents moments du cycle de vie Git.
Ils servent à automatiser des tâches, appliquer des règles, ou personnaliser le comportement de Git.

Les plus utiles au quotidien :



- **pre-commit** : avant la création du commit. Vérification, formatage, tests rapides.
- **commit-msg** : après avoir écrit le message, mais avant de finaliser. Parfait pour valider un format de commit.
- **pre-push** : avant l’envoi vers le dépôt distant. Idéal pour lancer des tests ou des checks de dernière minute.

Les hooks sont puissants pour maintenir la qualité et la cohérence d’une équipe.
Le problème : **les configurer à la main est fastidieux**. Et lourd à partager proprement entre machines ou devs.

C’est là qu’arrive [pre-commit](https://pre-commit.com/).
Un outil léger qui transforme la théorie des hooks Git en pratique partagée et reproductible.

## pre-co quoi ?

`pre-commit` est un framework pour gérer les hooks Git.
Écrit en Python, il est capable de supporter une multitude de langages et d’outils.

Sa force : tout se définit dans un seul fichier `.pre-commit-config.yaml` à la racine du dépôt.
Fini les scripts obscurs recopiés de machine en machine.

Et si les hooks existants ne suffisent pas, on peut définir les nôtres, sans douleur.



La [bibliothèque officielle](https://pre-commit.com/hooks.html) propose déjà une foule de hooks prêts à l’emploi :

- Formatters (Black, Prettier, etc.)
- Linters (ESLint, Flake8, etc.)
- Outils de sécurité (detect-secrets, truffleHog, etc.)

Et il est facile d'en trouver pléthore d'autres : [file:^.pre-commit-hooks.yaml$](https://sourcegraph.com/search?q=context:global+file:%5E.pre-commit-hooks.yaml%24&patternType=keyword&sm=0).

L'un des aspects bien pratique des plugins `pre-commit` est qu'ils s'installent dans un environnement isolé
(virtuel pour Python, conteneur pour d'autres langages) et peuvent être mis à disposition via un repo git.
Résultat : un standard clair, réplicable sur plusieurs projets, dans toute une organisation.

## Make it easy


Installer `pre-commit` est un jeu d’enfant. Mais comme je suis un gamin paresseux, alors on va intégrer ça dans un Makefile.


Points positifs à ma flemme proverbiale :

- trace: ça documente l'installation
- standardisation: les postes de dev sont identiques et faciles à mettre en place et mettre à jour
- onboarding:  plus rapide et reproducible
- ROI immédiat: moins de temps perdu à maintenir la stack de dev

Première étape : vérifier qu'on a tout ce qu'il faut.

Pour ça, j'ai choisi d'installer `pre-commit` avec `uv` (qui fera sans doute l'objet d'un futur article).
Il nous faut donc `uv` et `python3`.

```Makefile
check_dependencies:
    @command -v python3 >/dev/null 2>&1 || { echo >&2 "python3 is required but it's not installed."; }
    @uv --version || (echo "uv is not installed. Please run `make install`")
    @pre-commit --version || (echo "pre-commit is not installed. Please run `make install`")
```

Ici, je laisse volontairement l'Ops installer python3 lui-même en fonction de son système et de ses préférences.
Pour `uv` et `pre-commit`, j'ai choisi de les traiter comme dépendances directes du projet.

Cette étape de vérification sera appelée avant chaque commande du Makefile.

## Pre pre-commit

Avant d'installer pre-commit, on va d'abord ajouter le fichier de configuration `.pre-commit-config.yaml` à la racine du projet.

Voici un exemple minimaliste :

```yaml
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
default_install_hook_types:
    - pre-commit
    - commit-msg
    - pre-push

repos:
    - repo: meta
      hooks:
          - id: check-hooks-apply
          - id: check-useless-excludes
```

Il est également possible de générer ce fichier avec `pre-commit init-config`.

Bien. Nous avons le strict minimum pour commencer. Maintenant, demandons-nous ce dont notre projet a besoin en fonction des standards que nous voulons appliquer.
Ici, je vais vous montrer le fichier que j'utilise pour le blog.

```yaml
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
default_install_hook_types:
  - pre-commit
  - commit-msg
  - pre-push

repos:
  - repo: meta
    hooks:
      - id: check-hooks-apply
      - id: check-useless-excludes
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.2.0
    hooks:
      - id: trailing-whitespace
        exclude: '\.svg|webp$'
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
  - repo: https://github.com/commitizen-tools/commitizen
    rev: v4.8.3
    hooks:
      - id: commitizen
  - repo: https://github.com/DavidAnson/markdownlint-cli2
    rev: v0.18.1
    hooks:
      - id: markdownlint-cli2
        args: ["--config .markdownlint-cli2.yaml"]
```


Regardons ensemble les différentes sections :

- **default_install_hook_types** : ici, on installe les trois principaux (pre-commit, commit-msg, pre-push). → Une seule commande : pre-commit install --install-hooks.

- **repos** : liste des dépôts de hooks.

  - [meta](https://pre-commit.com/index.html#meta-hooks) : vérifie la config elle-même.

  - [pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks) : collection générique.

  - [commitizen](https://github.com/commitizen-tools/commitizen) : valide le format *conventional commit*.

  - [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) : vérifie la qualité du md (logique pour un blog écrit en… markdown).


Je n'ai pas spécifié les étapes git auxquelles chaque hook doit s'exécuter, car j'utilise ceux fournis par les plugins eux-mêmes.
Sachez que lorsqu'un plugin s'applique sur différents hook, il est possible de n'en choisir que quelques-uns en utilisant la clé `stages`.

À ce stade, on a un fichier de config partagé, versionné, reproductible. Pas besoin de se soucier de l'installation des hooks sur chaque machine ni de traîner un trouzaine de scripts.

Petit point sur les plugins.

Pour des raisons de supply chain ou de besoin spécifique, on peut vouloir héberger ses propres hooks.

Rien de plus simple avec `pre-commit`. Il suffit de créer un dépôt Git avec un fichier `.pre-commit-hooks.yaml` qui décrit les hooks.

En procédant ainsi, on rend les standards de l'équipe ou de l'organisation facilement partageables et réutilisables à travers plusieurs projets.

Pour les plus curieux, voici le lien vers la doc officielle : [Creating new hooks](https://pre-commit.com/index.html#new-hooks).

## Make it lazy

On a vu la config. Reste à l’installer.
Pas question de multiplier les “fais un `pip install` chez toi” ou les scripts bricolés.
On centralise tout dans un `Makefile`.

```Makefile
install:
    @if ! command -v uv &> /dev/null
    then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
    @if ! command -v pre-commit &> /dev/null
    then
        echo "pre-commit could not be found, installing..."
        uv tool install pre-commit;
    fi

    @echo "Installing hooks..."
    @pre-commit install --install-hooks;
```

Je pense que le code parle de lui-même. On installe `uv` puis `pre-commit` en global, puis on installe les hooks pour le projet courant.


Résultat :

- Chaque dev installe les hooks en une commande.
- Chaque dev appliq les mêmes standards sur le projet.
- Chaque review se concentre sur le fond, pas sur les miettes.

## Aaaaaaand action

Avec tout ça en place, on est prêt à *gitter*.

Petite subtilité, `pre-commit` exige que son fichier de config soit à minima staged pour s'exécuter.

On prépare donc sa tambouille et on commit / push comme d'hab'.

Il est possible de lancer les hooks manuellement avec :

```bash
pre-commit run --all-files # ici pour tout le repo sur l'étape pre-commit
# ce qui donne
[WARNING] Unstaged files detected.
[INFO] Stashing unstaged files to /home/llarousserie/.cache/pre-commit/patch1757244598-3206571.
Check hooks apply to the repository......................................Passed
Check for useless excludes...............................................Passed
Trim Trailing Whitespace.................................................Passed
Fix End of Files.........................................................Failed
- hook id: end-of-file-fixer
- exit code: 1
- files were modified by this hook

Fixing bin/check_dependencies.sh

Check Yaml...............................................................Passed
Check for added large files..............................................Passed
markdownlint-cli2........................................................Passed
[INFO] Restored changes from /home/llarousserie/.cache/pre-commit/patch1757244598-3206571
```

Ici, le hook `end-of-file-fixer` a corrigé un fichier → il suffit de re-stager et de re-commiter.

Certains hooks **auto-fixent** les fichiers (ex. whitespace, EOF, formatters).

D’autres (ex. `commitizen`) **bloque l'action** si la règle n’est pas respectée.

Astuce : on peut lancer un hook spécifique avec :

```bash
pre-commit run <hook_id>
```

Pratique pour tester une config ou faire du linting ponctuel.

## J'aime l'odeur du pre-commit le matin

`pre-commit` n’est pas une lubie de développeur ni un gadget de plus dans la stack.
C’est un filet de sécurité partagé, simple à mettre en place, et qui fait gagner bien plus qu’il ne coûte.

Avec Make en soutien, l’installation et la maintenance sont un jeu d’enfant.

Pour les devs : moins de frictions, moins de relectures absurdes, plus de focus sur le métier.
Pour les équipes : un standard commun, reproductible, qui traverse les projets et les machines.
Pour les cadres : un ROI invisible, mais réel — moins d’heures gaspillées à corriger des détails triviaux,
plus d’énergie consacrée à la valeur.

Grâce à `pre-commit`, les reviews deviennent zen, les commits propres, et les secrets bien gardés.
On a un gate keeper vigilant, mais discret et on évite d'accumuler les défauts et erreurs au fil du temps,
ce qui peut entrainer de la frustration et représenter un coût caché pour l'entreprise.

Bref : un petit outil, un grand soulagement.
Et des MR enfin bien léchées.
