extends Node3D

@export var porte_interact: NodePath
@export var indice_scene: PackedScene
@export var point_spawn_indice: NodePath

var _indice_spawn: bool = false

func interact() -> void:
	# Délègue d'abord à la porte pour l'animation (si présente)
	if porte_interact != NodePath(""):
		var porte = get_node_or_null(porte_interact)
		if porte and porte.has_method("interact"):
			porte.interact()

	if _indice_spawn or indice_scene == null:
		return

	_indice_spawn = true

	var indice: Node3D = indice_scene.instantiate()
	var cible_parent: Node3D = get_tree().current_scene
	var spawn_origin: Vector3 = global_transform.origin + Vector3(0, 1.0, 0)

	if point_spawn_indice != NodePath(""):
		var point = get_node_or_null(point_spawn_indice)
		if point and point is Node3D:
			spawn_origin = (point as Node3D).global_transform.origin

	indice.global_transform.origin = spawn_origin
	cible_parent.add_child(indice)

