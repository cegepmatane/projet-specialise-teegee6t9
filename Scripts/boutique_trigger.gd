extends StaticBody3D

var menu_ouvert: bool = false


func interact() -> void:
	if menu_ouvert:
		fermer_boutique()
	else:
		ouvrir_boutique()


func ouvrir_boutique() -> void:
	menu_ouvert = true
	get_tree().current_scene.ouvrir_boutique()


func fermer_boutique() -> void:
	menu_ouvert = false
	get_tree().current_scene.fermer_boutique()
