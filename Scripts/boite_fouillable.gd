extends StaticBody3D

@export var indice_scene: PackedScene
var fouillee: bool = false

func interact() -> void:
	if fouillee:
		return
	fouillee = true

	if indice_scene:
		var indice: Node3D = indice_scene.instantiate()
		indice.global_transform.origin = global_transform.origin + Vector3(0, 0.8, 0)
		get_tree().current_scene.add_child(indice)

	queue_free()

