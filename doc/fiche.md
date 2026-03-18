# Fiche projet — Silent Orbit

## Identité du projet
- **Nom** : Silent Orbit
- **Technologie** : Godot Engine 4.6, GDScript
- **Plateforme** : PC (Windows/Linux)
- **Type** : Jeu de puzzle/escape room en 3D à la première personne

## Description
Jeu d'évasion en 3D où le joueur doit trouver des indices dans une salle pour activer un téléporteur de sortie. Le joueur gagne de l'argent en complétant des parties et peut acheter de l'équipement dans une boutique physique dans le lobby.

## Fonctionnalités principales
- Système d'indices à ramasser
- Boutique d'équipement avec présélections
- Système de succès persistants
- Timer de partie avec échec si temps écoulé
- Sauvegarde persistante (save.cfg)

## Structure technique
- **Autoloads** : SuccessManager, EquipmentManager
- **Sauvegarde** : user://save.cfg (ConfigFile)
- **Données** : Data/successes.json, Data/equipment.json
