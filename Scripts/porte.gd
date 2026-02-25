extends StaticBody3D

var basculer = false
var interactive = true
@export var animation_joueur: AnimationPlayer

@export var indice_scene: PackedScene
var _indice_spawn: bool = false

func interact():
	if interactive == true:
		interactive = false
		basculer = !basculer
		if basculer == false:
			animation_joueur.play("Fermer")
		if basculer == true:
			animation_joueur.play("Ouvrir")

		if basculer == true and not _indice_spawn and indice_scene:
			_indice_spawn = true
			var indice: Node3D = indice_scene.instantiate()
			var parent_scene: Node = get_tree().current_scene
			var spawn_pos: Vector3 = global_transform.origin + global_transform.basis.z * -0.8 + Vector3.UP * 0.6
			if indice is Node3D:
				(indice as Node3D).global_transform.origin = spawn_pos
			parent_scene.add_child(indice)

		await get_tree().create_timer(1.0, false).timeout
		interactive = true
