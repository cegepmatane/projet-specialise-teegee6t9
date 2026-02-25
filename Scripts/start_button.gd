extends Node3D

@export var scene_cible: String = "res://Scenes/level.tscn"

func interact() -> void:
	get_tree().change_scene_to_file(scene_cible)
