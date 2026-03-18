# Cas d'utilisation — Boutique d'équipement

## CU-01 : Acheter de l'équipement
**Acteur** : Joueur  
**Précondition** : Joueur dans le lobby, argent suffisant  
**Postcondition** : Item ajouté à l'inventaire, argent déduit  

**Scénario nominal** :
1. INPUT — Joueur interagit avec le bouton boutique (touche E)
2. OUTPUT — Interface boutique s'ouvre, souris visible
3. INPUT — Joueur clique "Acheter" sur un item
4. OUTPUT — Quantité +1, argent déduit, bouton désactivé si max atteint

**Alternatif** : Pas assez d'argent → bouton désactivé

---

## CU-02 : Configurer un preset
**Acteur** : Joueur  
**Précondition** : Joueur a au moins un item en inventaire  
**Postcondition** : Preset sauvegardé dans save.cfg  

**Scénario nominal** :
1. INPUT — Joueur clique sur un slot de preset
2. OUTPUT — Slot devient jaune (sélectionné)
3. INPUT — Joueur clique "+" sur un item
4. OUTPUT — Item assigné au slot
5. INPUT — Joueur clique "Activer"
6. OUTPUT — Preset marqué "✓ Actif"

**Alternatif** : Cliquer sur "✓ Actif" → désactive le preset

---

## CU-03 : Lancer une partie
**Acteur** : Joueur  
**Précondition** : Joueur dans le lobby  
**Postcondition** : Scène de jeu chargée, équipement consommé  

**Scénario nominal** :
1. INPUT — Joueur interagit avec le bouton de départ
2. OUTPUT — Système vérifie preset actif et argent disponible
3. OUTPUT — Items achetés/consommés depuis l'inventaire
4. OUTPUT — Scène level.tscn chargée

**Alternatif 1** : Pas assez d'argent → popup erreur avec montant manquant  
**Alternatif 2** : Pas de preset actif → partie lance sans équipement

---

## CU-04 : Fin de partie
**Acteur** : Joueur / Système (timer)  
**Précondition** : Joueur en partie  

**Succès** :
1. Joueur entre dans le téléporteur de fin
2. +25$ ajoutés, succès vérifiés, retour lobby

**Échec (timer)** :
1. Timer atteint 0
2. Équipement perdu (reset_on_failure)
3. Écran noir "Mission échouée", retour lobby
