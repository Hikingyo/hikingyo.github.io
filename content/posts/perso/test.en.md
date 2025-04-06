---
title: "Test Style Playground"
date: "2025-04-05T22:00:00"
draft: true
author:
    name: "火金魚"
menu:
    sidebar:
        name: Test
        identifier: perso-test
        parent: perso
        weight: 10
---

# Main title (H1)

Un paragraphe de texte standard avec un peu de *mise en forme*, de **gras**, et de _soulignement simulé_.

## Secondary title (H2)

Here a link : [Ada Lovelace](https://en.wikipedia.org/wiki/Ada_Lovelace)  
And accent sentence `accent-color`.

Some muted color text :

<span class="text-muted">This is muted text (muted).</span>

And a fat <strong>strong</strong> in the face.

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