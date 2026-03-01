extends StaticBody3D

@export var indice_scene: PackedScene
@export var offset_spawn: Vector3 = Vector3(0, 0.8, 0)

var fouillee: bool = false
var _en_destruction: bool = false


func interact() -> void:
	# Sécurité absolue
	if not is_instance_valid(self):
		return
	if not is_inside_tree():
		return
	if fouillee or _en_destruction:
		return

	fouillee = true
	_en_destruction = true

	# On capture le transform AVANT toute suppression
	var spawn_pos: Vector3 = global_transform.origin + offset_spawn

	# Spawn de l'indice
	if indice_scene:
		var indice := indice_scene.instantiate()

		if indice is Node3D:
			var indice_3d := indice as Node3D
			get_tree().current_scene.add_child(indice_3d)
			indice_3d.global_transform.origin = spawn_pos
		else:
			push_warning("indice_scene doit avoir un Node3D comme racine")

	# Suppression en toute fin
	queue_free()
