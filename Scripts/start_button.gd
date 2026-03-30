extends Node3D

@export var scene_cible: String = "res://Scenes/level.tscn"


func interact() -> void:
	var preset_actif: String = EquipmentManager.obtenir_active_preset()

	# Pas de preset actif = lancer sans équipement
	if preset_actif == "":
		get_tree().change_scene_to_file(scene_cible)
		return

	var slots: Array = EquipmentManager.obtenir_preset(preset_actif)

	# Calculer ce qu'on doit acheter vs ce qu'on a déjà
	var a_acheter: Dictionary = {}
	for id in slots:
		if id == "":
			continue
		var qte_possedee: int = EquipmentManager.obtenir_quantite(id)
		var qte_deja_comptee: int = a_acheter.get(id + "_possede", 0)
		if qte_possedee > qte_deja_comptee:
			a_acheter[id + "_possede"] = qte_deja_comptee + 1
		else:
			a_acheter[id] = a_acheter.get(id, 0) + 1

	# Vérifier qu'on a assez d'argent
	var cout_total: int = 0
	for id in a_acheter.keys():
		if not id.ends_with("_possede"):
			cout_total += EquipmentManager.obtenir_prix(id) * a_acheter[id]

	if cout_total > EquipmentManager.obtenir_argent():
		var manque: int = cout_total - EquipmentManager.obtenir_argent()
		get_tree().current_scene.afficher_erreur(
			"Pas assez d'argent !\nCoût du preset : %d$\nIl te manque : %d$" % [cout_total, manque]
		)
		return

	# Acheter ce qui manque
	for id in a_acheter.keys():
		if not id.ends_with("_possede"):
			for i in range(a_acheter[id]):
				EquipmentManager.acheter(id)

	# Consommer tous les items du preset
	for id in slots:
		if id != "" and id != "chrono":
			EquipmentManager.consommer(id)

	EquipmentManager.appliquer_preset(preset_actif)
	get_tree().change_scene_to_file(scene_cible)
