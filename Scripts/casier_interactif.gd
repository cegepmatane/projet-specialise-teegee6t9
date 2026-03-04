extends Node3D

@export var animation_joueur: AnimationPlayer
@export var indice_scene: PackedScene
@export var point_spawn_indice: NodePath

var basculer: bool = false
var interactive: bool = true
var _indice_spawn: bool = false
var _en_traitement: bool = false

func interact() -> void:
	if not is_instance_valid(self):
		return
	if not is_inside_tree():
		return
	if not interactive or _en_traitement:
		return

	interactive = false
	_en_traitement = true
	basculer = !basculer

	if animation_joueur:
		if basculer:
			animation_joueur.play("Ouvrir")
		else:
			animation_joueur.play("Fermer")

	var spawn_pos: Vector3 = global_transform.origin + Vector3(0, 1.0, 0)

	if point_spawn_indice != NodePath(""):
		var point = get_node_or_null(point_spawn_indice)
		if point and point is Node3D and point.is_inside_tree():
			spawn_pos = (point as Node3D).global_transform.origin

	if basculer and not _indice_spawn and indice_scene:
		_indice_spawn = true

		var indice := indice_scene.instantiate()

		if indice is Node3D:
			var indice_3d := indice as Node3D
			get_tree().current_scene.add_child(indice_3d)
			indice_3d.global_transform.origin = spawn_pos
		else:
			push_warning("indice_scene doit avoir un Node3D comme racine")

	await get_tree().create_timer(1.0).timeout

	interactive = true
	_en_traitement = false
