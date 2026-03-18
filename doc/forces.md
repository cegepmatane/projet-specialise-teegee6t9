# Forces du projet

## Architecture
- Autoloads bien séparés (SuccessManager / EquipmentManager) — responsabilité unique
- Données externalisées en JSON — facile à modifier sans toucher au code
- Sauvegarde unifiée dans un seul fichier save.cfg

## Gameplay
- Boucle de jeu claire : lobby → achat → partie → récompense → lobby
- Système de présélections évite de reconfigurer l'inventaire à chaque partie
- Succès variés (temps, indices, parties) donnent des objectifs au joueur

## Technique
- Godot 4.6 — moteur moderne, gratuit, open source
- GDScript — syntaxe simple, bien intégré au moteur
- Système d'interaction par raycast réutilisable sur tous les objets
