extends CharacterBody3D

const VITESSE = 5.0
const VITESSE_SAUT = 3.5

var gravite = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var rayon_interaction: RayCast3D = $tete/Camera3D/RayCast3D
@onready var label_indices: Label = $HUD/IndiceLabel


func _ready() -> void:
	_mettre_a_jour_compteur_indices()


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


func _process(_delta: float) -> void:
	_mettre_a_jour_compteur_indices()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		_tenter_interaction()


func _tenter_interaction() -> void:
	if rayon_interaction == null:
		return

	if not rayon_interaction.is_colliding():
		return

	var touche: Object = rayon_interaction.get_collider()

	# Sécurité supplémentaire
	if touche == null or not is_instance_valid(touche):
		return

	var noeud: Object = touche

	# On remonte jusqu'à 4 parents max
	for i in range(4):
		if noeud == null:
			break

		# 🔐 Sécurité critique ici
		if not is_instance_valid(noeud):
			break

		if noeud is Node and not (noeud as Node).is_inside_tree():
			break

		if noeud.has_method("interact"):
			noeud.interact()
			return

		if noeud is Node:
			noeud = (noeud as Node).get_parent()
		else:
			break


func _mettre_a_jour_compteur_indices() -> void:
	if label_indices == null:
		return

	var trouves := IndiceManager.obtenir_nombre_trouves()
	var total := IndiceManager.obtenir_nombre_total()

	label_indices.text = "Indices %d/%d" % [trouves, total]
