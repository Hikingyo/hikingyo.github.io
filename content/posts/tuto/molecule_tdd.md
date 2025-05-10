---
title: "TDD pour rôles Ansible : écrire moins, tester mieux, respirer encore"
date: "2025-04-12T22:00:00"
draft: true
author: "火金魚"
menu:
    sidebar:
        name: TDD pour rôles Ansible
        identifier: perso-tdd-molecule
        parent: tuto
        weight: 10
---

# TDD pour rôles Ansible : écrire moins, tester mieux, respirer encore

## 💥 Pourquoi ce tutoriel

Les rôles Ansible sont parfois construits sur mesure, parfois hérités. Leur exécution directe en production reste fréquente, souvent par absence d’environnement de test ou sous la pression de l’urgence. Beaucoup sont le fruit d’un empilement progressif, sans documentation ni vision claire de leur portée. Les effets réels deviennent difficiles à tracer, et leur évolution engage un risque difficile à anticiper.

Ce tutoriel propose une méthode structurée pour clarifier les intentions, formaliser les comportements attendus et fiabiliser les effets produits.

Ce document s’adresse à celles et ceux qui cherchent à :

- Approfondir une pratique d’Ansible sans multiplier les risques
- Produire des rôles compréhensibles, testables, transférables
- Instaurer un cadre de confiance autour du code d’automatisation

Ce tutoriel ne couvre pas l’installation de ces outils ni les bases de leur utilisation. Il se concentre sur l’approche de test par le comportement appliquée à des rôles Ansible modulaires.

## 🧠 Ce qu’on va faire ici

Ce tutoriel constitue une introduction pragmatique au **TDD appliqué à Ansible**.
Il ne s’agit ni d’un effet de mode, ni d’un dogme technique, mais d’une approche destinée à concevoir des rôles fondés sur les comportements attendus, et non sur une accumulation de tâches.

L'exemple développé portera sur un **rôle modulaire**, testé avec **Molecule** et **Testinfra**, destiné à configurer une mini-stack réaliste.

> L’idée ?\
> Commencer simple, mais significatif.\
> Et construire **en testant chaque intention, pas chaque ligne.**

## ⚙️ Prérequis

Connaissances préalables recommandées :

- Notions de base sur `ansible`
- Maîtrise d’un système de conteneurisation (ici `podman`)

## 🗂️ Structure du projet

Le projet repose sur une architecture modulaire, organisée autour des principes suivants :

Un rôle par outil ou composant technique (ex : tool-nginx, tool-supervisord, tool-rsyslog, etc.)

Un rôle de composition (service-web) qui orchestre les différents outils pour produire un service exploitable

Des tests automatisés pour chaque étape à l’aide de Molecule et Testinfra, suivant les principes du Test Driven Development (TDD)

Cette organisation permet de :

Réutiliser les rôles indépendamment dans d’autres contextes

Spécialiser la configuration dans le rôle de service

Documenter les comportements attendus par les tests

## 🧪 Installation de Molecule et Testinfra

Pour mettre en œuvre le TDD dans un environnement Ansible, deux outils principaux seront utilisés :

Molecule : un outil de test pour rôles Ansible. Il permet de valider le comportement d’un rôle dans un environnement isolé.

Testinfra : une bibliothèque Python permettant d’écrire des tests d’infrastructure, en s’appuyant sur pytest. Il est possible d'utiliser Ansible lui-même et d'autres encore.

L’installation des dépendances peut se faire dans un environnement Python dédié (via venv, pipenv ou poetry). Personnellement, j'utilise [UV](https://docs.astral.sh/uv/)

### Installation de Molecule

La documentation pour l'installation de Molecule est disponible [ici](https://ansible.readthedocs.io/projects/molecule/installation).

```bash
pip install --upgrade --user setuptools
pip install  ansible-dev-tools
pip install --user molecule
pip install --user "molecule-plugins[podman]"
```

### Installation de Testinfra

La documentation pour l'installation de Testinfra est disponible [ici](https://testinfra.readthedocs.io/en/latest/).

```bash
pip install pytest-testinfra
```

## Initialisation du projet

Maintenant, nous sommes prêts à entrer dans le vif su sujet. Nous allons commencer par créer notre projet avec `ansible-galaxy`

```bash
ansible-galaxy collection init hikingyo.tuto_molecule_tdd
```

Cette commande crée une structure de répertoire de base pour notre projet, avec les fichiers et dossiers nécessaires.
Nous allons ensuite créer un rôle de base pour notre projet. Nous allons créer un rôle qui installe et configure un serveur web Nginx.

```bash
cd hikingyo.tuto_molecule_tdd/roles
ansible-galaxy init tool_nginx
```

Nous avons maintenant préparé notre projet pour utiliser molecule.

```bash
# depuis la racine du projet
mkdir playbooks
touch playbooks/site.yml
mkdir extensions
cd extensions
```

Et enfin, l'initialisation de molecule

```bash
molecule init scenario
```
Cette commande crée un scénario de test par défaut dans le répertoire `molecule/default`. Ce scénario contient des fichiers de configuration et des tests de base pour notre rôle.

Nous allons présenter chacun des fichiers créés par Molecule et expliquer leur rôle au fur et à mesure de l'avancement du tutoriel.

## Le TDD : un outil, pas une religion

Avant d'entrer dans le dur, on pose les bases.

Le TDD, dans les livres, c’est “Red, Green, Refactor”. Ce principe se décline en trois étapes :

1. **Red** : Écrire un test qui échoue (rouge)
2. **Green** : Écrire le code minimal pour faire passer le test (vert)
3. **Refactor** : Améliorer le code tout en s'assurant que les tests passent toujours
4. **Repeat** : Recommencer à l'étape 1

Mais dans la réalité ?

Tu codes souvent sous pression, dans un terrain pas clair, avec une base code où tout peut casser sans bruit.

Alors le TDD devient un garde-fou. Pas un dogme.

Il te force à formuler ce que tu veux avant de l’avoir.

Et ça, c’est un levier redoutable.

Toutefois, il a plusieurs limites :

- Il ne permet pas de tester les effets de bord
- Il ne permet pas de tester les performances
- Il ne permet pas de tester la sécurité

Si on le suit à la lettre, on peut facilement tomber dans le biais du code qui mime un résultat et avoir un beau mensonge à l'arrivée.

Il y a aussi l'obsession de la couverture de code, qui peut amener à écrire des tests pour des cas qui ne sont pas pertinents. Il est donc important de garder à l'esprit que le TDD est un outil, et non une fin en soi et qu'il faut toujours douter de ce que l'on fait, le remettre en question, et se demander si ce que l'on fait est pertinent.

On commence d'abord par réfléchir à ce que l'on veut faire, concevoir l'architecture, jeter les bases avec des commentaires, et ensuite, on commence à écrire les tests. On peut aussi écrire des tests pour des cas qui ne sont pas encore implémentés, mais qui sont pertinents pour le projet.

C'est cette approche que je souhaite partager avec vous dans ce tutoriel. Une approche qui me vient de ma pratique du TDD en tant que développeur.

## 🧪 Manuel du petit chimiste : épisode 1

> Disclaimer :\
> Les containers podman et docker n'embarquent pas de système d'init.\
> Il faut donc simuler un système d'init pour que le service fonctionne.\
> On va utiliser supervisord pour ça.\

Avant même de commencer à écrire du code ou un test, on va préparer notre environnement de test, le System Under Test (SUT).

Laissons de côté le scénario  `default` que nous utiliserons pour tester le service, et concentrons-nous sur le rôle `tool_supervisor`.

```bash
molecule init scenario -d podman --provisioner-name ansible tool_supervisor
```

Avec molecule, le SUT se fait dans le fichier `molecule.yml` qui se trouve dans le répertoire du scenario `molecule/tool_supervisor/molecule.yml`.

Et parce que souvent, une infra n'est pas homogène en termes de distro et de version, on va créer quatre plateformes différentes.

```yaml
---
dependency:
    name: galaxy

driver:
    name: podman

platforms:
    - name: debian11
      image: debian:bullseye
      pre_build_image: false
    - name: debian12
      image: debian:bookworm
      pre_build_image: false
    - name: almalinux8
      image: almalinux:8
      pre_build_image: false
    - name: almalinux9
      image: almalinux:9
      pre_build_image: false

provisioner:
    name: ansible
    env:
        ANSIBLE_CONFIG: ${MOLECULE_SCENARIO_DIRECTORY}/ansible.cfg
    lint: |
        ansible-lint
        yamllint .

verifier:
    name: testinfra
    options:
        lint: flake8
```

Décortiquons ce fichier :

- **dependency** : On utilise `galaxy` pour gérer les dépendances de notre rôle. Ici, on dit à molecule de se baser sur le fichier meta/main.yml pour récupérer les dépendances.
- **driver** : On utilise `podman` comme driver pour créer nos containers. On pourrait aussi utiliser `docker`, mais je préfère `podman` pour des raisons de sécurité et de simplicité.
- **platforms** : On définit quatre plateformes différentes sur lesquelles on va tester notre rôle. On utilise des images de base Debian et AlmaLinux.
- **provisioner** : On utilise `ansible` comme provisioner pour installer et configurer notre rôle. On utilise aussi `ansible-lint` et `yamllint` pour vérifier la qualité de notre code.
- **verifier** : On utilise `testinfra` comme vérificateur pour tester notre rôle. On utilise aussi `flake8` pour vérifier la qualité de notre code.

A ce stade, on a des jolis containers qui ne serve pas à grand-chose. Maintenant, il faut y jouer notre role. C'est là que le fichier `converge.yml` intervient.

```yaml
---
- name: Converge
  hosts: all
  vars:
      tool_supervisor_configs:
          - src: "supervisor_app.conf.j2"
            dest: "/etc/supervisor/conf.d/myapp.conf"
  roles:
      - tool_supervisor
```

Ce fichier est assez simple. Il applique le rôle `tool_supervisor` sur toutes les plateformes définies dans le fichier `molecule.yml`, sans fioritures. Le but ici est de tester le rôle dans le cas le plus simple possible.

Par contre, il nous reste une chose à faire pour que molecule puisse fonctionner. Il faut lui dire où se trouvent les rôles et les collections. Pour ça, on va créer un fichier `ansible.cfg` dans le répertoire `molecule/tool_supervisor/` avec le contenu suivant :

```ini
[defaults]
# ⬇️ Vers les rôles internes à ta collection
roles_path = ../../../roles

# ⬇️ Vers la racine de ta collection
collections_path = ../../../..

# ⬇️ Affichage plus lisible lors des tests
stdout_callback = yaml

# ⬇️ Empêche la génération de fichiers inutiles
retry_files_enabled = false

# ⬇️ Laisse Ansible choisir automatiquement le bon interpréteur Python
interpreter_python = auto_silent
```

Si votre IDE est aussi relou que le mien, il va vous dire qu'il ne connait pas le role `tool_supervisor`. C'est l'un des inconvénients de l'utilisation de molecule. Il faut lui dire où se trouvent les rôles et les collections. Et malgré ça, l'IDE ne va pas comprendre que le role `tool_supervisor` est  dans le répertoire `roles/tool_supervisor`.

Et c'est là que les choses commence.

Lançons molecule et regardons ce qu'il se passe.

```bash
~/tuto_molecule_tdd/hikingyo/tuto_molecule_tdd/extensions# molecule test -s tool_supervisor

```
#TODO config des path pour role et collection. !!
#TODO premier run ça pête parce que l'image alma n'est pas encore prête pour ansible dnf
