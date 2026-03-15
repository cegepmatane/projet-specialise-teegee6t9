extends Node3D

var sensibilite = 0.002

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		get_parent().rotate_y(-event.relative.x * sensibilite)
		rotate_x(-event.relative.y * sensibilite)
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
