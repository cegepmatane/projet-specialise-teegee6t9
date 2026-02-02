extends StaticBody3D

var basculer = false
var interactive = true
@export var animation_joueur: AnimationPlayer

func intract():
	if interactive == true:
		interactive = false
		basculer = !basculer
		if basculer == false:
			animation_joueur.play("Fermer")
		if basculer == true:
			animation_joueur.play("Ouvrir")
		await get_tree().create_timer(1.0, false).timeout
		interactive = true
