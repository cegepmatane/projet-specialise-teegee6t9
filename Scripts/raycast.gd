extends RayCast3D

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if is_colliding():
		var objet_touche = get_collider()
		if Input.is_action_just_pressed("interagir") and objet_touche and objet_touche.has_method("interact"):
			objet_touche.interact()
