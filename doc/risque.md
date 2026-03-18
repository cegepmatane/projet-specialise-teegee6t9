# Analyse des risques

## Risques techniques
| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| Corruption du save.cfg | Faible | Élevé | Valeurs par défaut si fichier manquant |
| Autoloads dans mauvais ordre | Moyenne | Moyen | charger_depuis_disque() dans _ready() de chaque scène |
| Fuite mémoire (nœuds non libérés) | Moyenne | Moyen | queue_free() systématique |
| NotebookLM sans API | Élevée | Faible | Import manuel documenté |

## Risques de projet
| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| Manque de temps pour nouvelles salles | Élevée | Moyen | Une salle bien finie vaut mieux que plusieurs incomplètes |
| Scope creep (trop de fonctionnalités) | Moyenne | Élevé | DoD stricte par itération |
| Dette technique (code non documenté) | Moyenne | Moyen | doc/EquipmentManager.md maintenu à jour |
