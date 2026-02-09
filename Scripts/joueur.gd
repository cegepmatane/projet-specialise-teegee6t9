extends CharacterBody3D

const VITESSE = 5.0
const VITESSE_SAUT = 3.5

var gravite = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var interact_ray: RayCast3D = $tete/Camera3D/RayCast3D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("sauter") and is_on_floor():
		velocity.y = VITESSE_SAUT

	var input_dir := Input.get_vector("gauche", "droite", "avancer", "reculer")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * VITESSE
		velocity.z = direction.z * VITESSE
	else:
		velocity.x = move_toward(velocity.x, 0, VITESSE)
		velocity.z = move_toward(velocity.z, 0, VITESSE)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_try_interact()


func _try_interact() -> void:
	if interact_ray == null:
		return

	if not interact_ray.is_colliding():
		return

	var hit: Object = interact_ray.get_collider()  # on donne un type
	if hit == null:
		return

	# On remonte éventuellement au parent pour trouver un node avec une méthode `interact`
	var node: Object = hit
	for i in range(4):
		if node == null:
			break
		if node.has_method("interact"):
			node.interact()
			return
		if node is Node:
			node = (node as Node).get_parent()
		else:
			break
