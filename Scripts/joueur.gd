extends CharacterBody3D


const VITESSE = 5.0
const VITESSE_SAUT = 3.5

var gravite = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("sauter") and is_on_floor():
		velocity.y = VITESSE_SAUT

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("gauche", "droite", "avancer", "reculer")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * VITESSE
		velocity.z = direction.z * VITESSE
	else:
		velocity.x = move_toward(velocity.x, 0, VITESSE)
		velocity.z = move_toward(velocity.z, 0, VITESSE)

	move_and_slide()
