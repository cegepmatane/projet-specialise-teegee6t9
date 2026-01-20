# Grille de comparaison pour la techno – Jeu 3D d’enquête en station spatiale

## Contexte
Projet : jeu vidéo 3D à la première personne d’enquête dans une station spatiale abandonnée, avec IA basique, ambiance sonore et visuelle travaillée, parties rejouables d’environ 20 minutes.

Technos comparées :

- **Godot 4**
- **Unreal Engine 5**
- **Unity (LTS)**

---

## Tableau comparatif

### Utilisabilité

| Critère                            | Godot 4                                                                 | Unreal Engine 5                                                          | Unity (LTS)                                                             |
|------------------------------------|-------------------------------------------------------------------------|---------------------------------------------------------------------------|-------------------------------------------------------------------------|
| **UX & couleurs (éditeur)**        | Interface assez simple et légère, rapide à prendre en main. Layout personnalisable, moins chargée que Unreal. | Interface puissante mais très chargée, beaucoup de panneaux et d’options. Peut intimider au début. | Interface entre les deux : plus simple qu’Unreal, mais avec beaucoup de menus et fenêtres. |
| **Librairies / modules** *(souhaitable)* | Fonctionnalités 2D/3D intégrées, bon support pour scripting, navmesh, audio. Moins d’assets prêts à l’emploi que Unity/Unreal, mais une Asset Library communautaire existe. | Très riche en modules : IA avancée, physique, VFX, outils cinématiques. Beaucoup de plugins officiels et tiers. | Enorme écosystème de packages et d’assets (Asset Store), beaucoup de scripts, shaders, systèmes déjà prêts. |
| **Format (export et envoi)** *(souhaitable)* | Export facile vers desktop (Windows / Linux / macOS). Système d’export intégré, open source. | Export vers de nombreuses plateformes, mais le build peut être lourd. Configuration parfois plus complexe. | Export vers beaucoup de plateformes, outils de build matures, mais certains réglages peuvent être complexes. |
| **Rapidité (prise en main & itérations)** | Démarre vite, compilations rapides en général. Bon pour tester souvent et faire beaucoup d’itérations. | Plus lourd à lancer, temps de compilation / cuisson des shaders parfois long. Très puissant mais coûteux en temps. | Assez rapide, mais les gros projets peuvent devenir lourds. Temps de compilation des scripts parfois notable. |

### Pérennité

| Critère                            | Godot 4                                                                 | Unreal Engine 5                                                          | Unity (LTS)                                                             |
|------------------------------------|-------------------------------------------------------------------------|---------------------------------------------------------------------------|-------------------------------------------------------------------------|
| **Coût** *(OBLIGATOIRE)*          | Gratuit et open source. Aucune redevance, même en cas de sortie commerciale. | Gratuit pour le développement, royalties au-delà d’un certain seuil de revenus. | Licence gratuite au départ, mais modèle économique pouvant changer (polémiques récentes sur les coûts par installation). |
| **Licence** *(OBLIGATOIRE)*       | Licence MIT, très permissive. Code source disponible sur GitHub.       | Licence propriétaire d’Epic Games. Moteur fermé, mais très utilisé dans l’industrie. | Licence propriétaire Unity. Outils gratuits mais avec conditions et possibles changements de politique. |
| **Interopérabilité (protocoles, formats)** *(souhaitable)* | Support des formats 3D courants (.glb, .gltf, .fbx), scripts en GDScript/C#/C++ natif. Export de données possible via JSON, fichiers, etc. | Très bon support de nombreux formats 3D, pipelines professionnels (FBX, etc.), intégration avec logiciels comme Maya, Blender. | Bon support des formats 3D courants, intégration poussée avec de nombreux outils via plugins. |
| **Sécurité / stabilité**          | Encore en évolution pour la 3D avec Godot 4, mais communauté active et corrections fréquentes. Pour un petit projet étudiant, suffisant. | Moteur très mature pour les gros projets AAA. Stable mais complexe à configurer correctement. | Moteur très utilisé, mais certaines mises à jour peuvent casser des projets. Nécessité de rester sur une version LTS. |

### Autres critères

| Critère                            | Godot 4                                                                 | Unreal Engine 5                                                          | Unity (LTS)                                                             |
|------------------------------------|-------------------------------------------------------------------------|---------------------------------------------------------------------------|-------------------------------------------------------------------------|
| **App internes / tooling**        | Éditeur de scènes intégré, débogueur, profiler, outils de navigation. Moins d’outils avancés que les autres mais suffisant pour un projet étudiant. | Beaucoup d’outils intégrés (cinématiques, VFX, audio avancé, profiling complet). Très puissant mais complexe. | Bon ensemble d’outils intégrés, avec possibilité d’ajouter des extensions via le Package Manager. |
| **API**                           | API simple, documentée, GDScript proche de Python. Bonne pour apprendre rapidement la logique de jeu. | API C++ puissante mais complexe. Blueprints permettent de faire beaucoup de choses sans coder, mais la courbe d’apprentissage reste importante. | API C# assez accessible si on connaît déjà la programmation objet. Beaucoup de tutos et d’exemples. |
| **Automatisations (build, scripts)** | Possibilité d’automatiser via scripts (GDScript, scripts d’édition) et CI simple sur projets Godot. | Outils professionnels pour pipelines de build, intégration dans de gros workflows (studios). Plus lourd à mettre en place pour un petit projet. | Intégration avec CI/CD assez courante, outils de build en ligne (Cloud Build), mais un peu trop lourd pour un petit projet solo. |
