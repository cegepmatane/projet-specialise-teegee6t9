extends CharacterBody3D

const VITESSE = 5.0
const VITESSE_SAUT = 3.5

var gravite = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var rayon_interaction: RayCast3D = $tete/Camera3D/RayCast3D
@onready var label_indices: Label = $HUD/IndiceLabel
@onready var lampe: SpotLight3D = $tete/Camera3D/LampePoche

var _lampe_allumee: bool = false


func _ready() -> void:
	_mettre_a_jour_compteur_indices()
	if lampe:
		lampe.visible = false


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
	# Lampe / lunettes avec A
	if event.is_action_pressed("lampe"):
		_toggle_lampe()
		return

	# Chrono d'urgence avec C
	if event.is_action_pressed("chrono"):
		_utiliser_chrono()
		return

	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		_tenter_interaction()


func _toggle_lampe() -> void:
	if not lampe:
		return

	# Vérifier lampe OU lunettes dans les slots actifs
	var slots: Array = EquipmentManager.obtenir_slots_actifs()
	var a_eclairage: bool = slots.has("lampe") or slots.has("lunettes")

	if not a_eclairage and not _lampe_allumee:
		print("[LAMPE] Aucun item d'éclairage équipé")
		return

	# Lunettes = lumière plus large et moins intense
	if slots.has("lunettes") and not slots.has("lampe"):
		lampe.spot_angle = 60.0
		lampe.light_energy = 0.8
	else:
		lampe.spot_angle = 25.0
		lampe.light_energy = 2.0

	_lampe_allumee = not _lampe_allumee
	lampe.visible = _lampe_allumee
	print("[LAMPE] Éclairage :", "allumé" if _lampe_allumee else "éteint")


func _utiliser_chrono() -> void:
	var slots: Array = EquipmentManager.obtenir_slots_actifs()
	if not slots.has("chrono"):
		print("[CHRONO] Chrono non équipé")
		return

	var timer_node: Node = null
	var joueurs := get_tree().get_nodes_in_group("Joueur")
	if joueurs.size() > 0:
		timer_node = joueurs[0].get_node_or_null("HUD/TimerPartie")

	if timer_node == null:
		print("[CHRONO] Timer introuvable")
		return

	# Ajouter 60 secondes
	timer_node._temps_restant += 60.0
	print("[CHRONO] +60 secondes ! Temps restant : ", timer_node._temps_restant)

	# Retirer le chrono des slots
	var index: int = slots.find("chrono")
	EquipmentManager.equiper_slot(index, "")

	# Flash vert sur le timer IMMÉDIATEMENT
	var label_timer := timer_node.get_node_or_null("LabelTimer")
	if label_timer:
		timer_node._chrono_actif = true
		label_timer.add_theme_color_override("font_color", Color(0.2, 1, 0.2))

	# Flash rouge sur le slot IMMÉDIATEMENT
	var hud_inventaire := get_node_or_null("HUD/HUDInventaire")
	if hud_inventaire:
		var panneau = hud_inventaire._panneaux[index]
		var label: Label = panneau.get_node("Label")
		label.add_theme_color_override("font_color", Color(1, 0.2, 0.2))

	# Attendre puis réinitialiser les deux
	await get_tree().create_timer(2.0).timeout

	if label_timer:
		timer_node._chrono_actif = false
		label_timer.add_theme_color_override("font_color", Color(1, 1, 1))
	if hud_inventaire:
		hud_inventaire.rafraichir()


func _tenter_interaction() -> void:
	if rayon_interaction == null:
		return

	if not rayon_interaction.is_colliding():
		return

	var touche: Object = rayon_interaction.get_collider()

	if touche == null or not is_instance_valid(touche):
		return

	var noeud: Object = touche

	for i in range(4):
		if noeud == null:
			break
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
