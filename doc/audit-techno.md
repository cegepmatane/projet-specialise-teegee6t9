# Audit technologique — Silent Orbit
> Audit réalisé avec NotebookLM/Gemini — Avril 2026

---

## Résumé exécutif

Le projet repose sur une stack moderne (Godot 4.6 + GDScript) globalement saine et adaptée à un projet étudiant. Le principal risque ne vient pas du moteur mais de l'architecture interne et des dépendances non maîtrisées (plugins, assets). Sans structuration claire, la complexité va rapidement exploser avec l'ajout de systèmes. Il n'y a pas de vulnérabilités critiques connues, mais un risque technique latent lié au couplage et à l'évolution de Godot 4.x.

**Score global : 7.5 / 10**

---

## A) Santé des dépendances

| Dépendance | Statut | Risque | Notes |
|---|---|---|---|
| Godot Engine 4.6 | ✅ Actif | 🟢 Faible | Open-source très actif |
| GDScript | ✅ Actif | 🟢 Faible | Maintenu avec Godot |
| Navigation (Godot) | ✅ Actif | 🟢 Faible | Stable en 4.x |
| Assets 3D externes | ⚠️ Variable | 🟡 Moyen | Dépend des sources |
| Plugin StarField | ✅ Actif | 🟢 Faible | Utilisé pour skybox étoiles |

### Annotations

✅ **Godot 4.6 est sain** — En effet, le moteur est très actif et nous n'avons rencontré aucun bug critique lié au moteur lui-même durant tout le développement.

⚠️ **Assets 3D "risque moyen"** — L'IA a partiellement raison. Nous avons effectivement eu des problèmes d'import (formats incompatibles, échelle incorrecte) mais cela a été résolu rapidement en passant par le format GLB.

❌ **"Plugins inconnus = risque critique"** — L'IA manquait d'information. Notre seul plugin externe est StarField pour les étoiles, qui est simple et bien documenté. Le risque réel était minimal.

---

## B) Maturité de la techno principale (Godot)

| Critère | Score | Analyse |
|---|---|---|
| Communauté | 🟢 Très forte | Explosion depuis 2020 |
| Croissance | 🟢 Très rapide | Adoption indie + pro |
| Support long terme | 🟢 Bon | Fondation stable |
| Écosystème | 🟡 Moyen | Moins riche que Unity |
| Stabilité 3D | 🟡 Correcte | Encore en évolution |
| Documentation | 🟢 Bonne | Très accessible |

### Annotations

✅ **"Excellent choix pour un projet étudiant"** — Totalement d'accord. La courbe d'apprentissage de GDScript est douce et la documentation officielle est très accessible, ce qui a permis de développer rapidement des systèmes complexes comme l'EquipmentManager et le SuccessManager.

⚠️ **"Breaking changes fréquents entre versions"** — Partiellement vrai. Nous avons eu quelques ajustements mineurs en passant de 4.5 à 4.6 mais rien de bloquant. L'IA exagère légèrement le risque pour un projet de courte durée.

---

## C) Architecture & choix techniques

### Points forts identifiés

- ✅ Séparation Lobby / Game
- ✅ Interaction via RayCast3D
- ✅ Autoloads (SuccessManager, EquipmentManager) comme couche manager

### Risques identifiés

- ⚠️ Anti-pattern "God Object Player" — joueur.gd contient mouvement + interaction + UI
- ⚠️ Couplage fort entre certains systèmes
- ⚠️ Logique dispersée dans plusieurs scripts

### Annotations

✅ **"Bonne séparation Lobby/Game"** — Effectivement, dès le début nous avons séparé les scènes lobby et level, avec des Autoloads pour la persistance. C'est un choix qui a payé — ajouter de nouvelles fonctionnalités n'a jamais cassé l'existant.

⚠️ **"Anti-pattern God Object sur Player.gd"** — Partiellement vrai. Notre joueur.gd gère effectivement plusieurs responsabilités (mouvement, interaction, lampe, lunettes, chrono) mais dans le contexte d'un projet étudiant de cette taille, cela reste gérable. Un refactor complet aurait coûté trop de temps.

❌ **"Architecture recommandée avec /scripts/core et /scripts/systems"** — Dans notre cas, la structure actuelle fonctionne bien. Godot encourage une architecture par scènes et non par dossiers de scripts. Appliquer une structure MVC stricte aurait compliqué le développement sans bénéfice réel pour ce scope de projet.

---

## D) Alternatives émergentes

| Tech | Avantages | Inconvénients | Migration |
|---|---|---|---|
| Unity | Mature, asset store énorme | Runtime fees | 🔴 Élevé |
| Unreal Engine 5 | Ultra réaliste | Complexe | 🔴 Très élevé |
| Bevy (Rust) | Performant, ECS natif | Très difficile | 🔴 Très élevé |
| Godot (actuel) | Simple, open source | 3D moins mature | 🟢 Déjà utilisé |

### Annotations

✅ **"Godot est le bon choix, migration coûteuse"** — Tout à fait d'accord. Changer de moteur en cours de projet aurait été catastrophique. Godot 4.6 a répondu à tous nos besoins.

⚠️ **"GDScript → C# pour la performance"** — Pas pertinent pour notre projet. Nous n'avons jamais rencontré de problèmes de performance avec GDScript. Cette recommandation s'applique à des projets plus grands.

---

## Plan d'action priorisé

### 🔴 HAUTE PRIORITÉ
- Documenter les dépendances externes (plugins, assets)
- Isoler davantage la logique de joueur.gd

### 🟡 PRIORITÉ MOYENNE
- Centraliser les systèmes dans un dossier /scripts/systems
- Améliorer les logs de debug

### 🟢 BASSE PRIORITÉ
- Optimisation 3D (draw calls, polycount)
- Veille sur évolutions Godot 4.x
- Migration GDScript → C# si projet grossit

---

*Audit réalisé le avril 2026 — Silent Orbit v1.0*
