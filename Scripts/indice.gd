extends Node3D

@export var type_indice: String = "couleur"  # "couleur" ou "chiffre"
@export var position_indice: int = 1         # 1 à 5

var _ramasse: bool = false


func interact() -> void:
	if _ramasse:
		return
	_ramasse = true

	# Récupérer la valeur selon le code généré
	var valeur: String = ""
	if type_indice == "couleur":
		valeur = IndiceManager.code_couleurs[position_indice - 1]
		print("[INDICE] Couleur %d : %s" % [position_indice, valeur])
	elif type_indice == "chiffre":
		valeur = str(IndiceManager.code_chiffres[position_indice - 1])
		print("[INDICE] Chiffre %d : %s" % [position_indice, valeur])

	# Afficher l'indice au joueur
	var racine := get_tree().current_scene
	if racine and racine.has_method("afficher_indice"):
		racine.afficher_indice(type_indice, position_indice, valeur)

	IndiceManager.ramasser_indice("%s_%d" % [type_indice, position_indice])
	queue_free()
