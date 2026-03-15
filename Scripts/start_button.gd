extends Node3D

@export var scene_cible: String = "res://Scenes/level.tscn"


func interact() -> void:
	# Appliquer le preset actif si un est sélectionné
	var preset_actif := EquipmentManager.obtenir_active_preset()
	if preset_actif != "":
		EquipmentManager.appliquer_preset(preset_actif)
	else:
		# Sinon appliquer preset_1 par défaut
		EquipmentManager.appliquer_preset("preset_1")

	get_tree().change_scene_to_file(scene_cible)
