---
title: "Test Style Playground"
date: "2025-04-05T22:00:00"
draft: true
author: "火金魚"
menu:
    sidebar:
        name: Test
        identifier: perso-test
        parent: perso
        weight: 10
---

# Titre principal (H1)

Un paragraphe de texte standard avec un peu de *mise en forme*, de **gras**, et de *soulignement simulé*.

## Titre secondaire (H2)

Voici un lien : [Vers Ada Lovelace](https://en.wikipedia.org/wiki/Ada_Lovelace)
Et un autre avec `accent-color`.

Un peu de texte en couleur atténuée :

<span class="text-muted">Ceci est un texte atténué (muted).</span>

Et une grosse <strong>strong</strong> dans la tronche.

---

### Code block & inline

Un exemple en `inline code` : `let glitch = true;`

```ts
// Code block
function glitch() {
  const msg = "Welcome to the Adaverse";
  console.log(msg);
}
```

---

### Alertes

<div class="alert alert-success">
  <strong>Succès !</strong> C’est le style pour les messages positifs.
</div>

<div class="alert alert-warning">
  <strong>Attention !</strong> Ceci est un avertissement.
</div>

<div class="alert alert-info">
  <strong>Info !</strong> Quelque chose a mal tourné.
</div>

<div class="alert alert-danger">
  <strong>Erreur !</strong> Quelque chose a mal tourné.
</div>
