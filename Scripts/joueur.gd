extends CharacterBody3D

const VITESSE = 5.0
const VITESSE_SAUT = 3.5

var gravite = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var rayon_interaction: RayCast3D = $tete/Camera3D/RayCast3D
@onready var label_indices: Label = $HUD/IndiceLabel
@onready var lampe: SpotLight3D = $tete/Camera3D/LampePoche
@onready var barre_batterie: ProgressBar = $HUD/BarreBatterie

var _lampe_allumee: bool = false
var _lunettes_allumees: bool = false

# Batterie lunettes
const BATTERIE_MAX: float = 30.0
const RECHARGE_DUREE: float = 15.0
var _batterie: float = 30.0
var _en_recharge: bool = false


func _ready() -> void:
	_mettre_a_jour_compteur_indices()
	if lampe:
		lampe.visible = false
	if barre_batterie:
		barre_batterie.max_value = BATTERIE_MAX
		barre_batterie.value = _batterie
		barre_batterie.visible = false


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

	# Gestion batterie lunettes
	_mettre_a_jour_batterie(delta)


func _process(_delta: float) -> void:
	_mettre_a_jour_compteur_indices()


func _mettre_a_jour_batterie(delta: float) -> void:
	var slots: Array = EquipmentManager.obtenir_slots_actifs()
	if not slots.has("lunettes"):
		return

	if _lunettes_allumees and not _en_recharge:
		_batterie -= delta
		if _batterie <= 0.0:
			_batterie = 0.0
			_eteindre_lunettes()
			_en_recharge = true
			print("[LUNETTES] Batterie épuisée, recharge...")
	elif _en_recharge:
		_batterie += delta * (BATTERIE_MAX / RECHARGE_DUREE)
		if _batterie >= BATTERIE_MAX:
			_batterie = BATTERIE_MAX
			_en_recharge = false
			print("[LUNETTES] Batterie rechargée !")

	if barre_batterie:
		barre_batterie.value = _batterie
		# Couleur selon charge
		if _en_recharge:
			barre_batterie.modulate = Color(1, 0.5, 0)  # Orange = recharge
		elif _batterie < 10.0:
			barre_batterie.modulate = Color(1, 0.2, 0.2)  # Rouge = critique
		else:
			barre_batterie.modulate = Color(0.2, 1, 0.2)  # Vert = ok


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("lampe"):
		_toggle_lampe()
		return

	if event.is_action_pressed("lunettes"):
		_toggle_lunettes()
		return

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

	var slots: Array = EquipmentManager.obtenir_slots_actifs()
	var a_lampe: bool = slots.has("lampe")

	if not a_lampe and not _lampe_allumee:
		print("[LAMPE] Lampe non équipée")
		return

	_lampe_allumee = not _lampe_allumee

	# Recalculer l'effet selon ce qui est équipé
	_appliquer_effet_eclairage()
	print("[LAMPE] Lampe :", "allumée" if _lampe_allumee else "éteinte")


func _toggle_lunettes() -> void:
	var slots: Array = EquipmentManager.obtenir_slots_actifs()
	if not slots.has("lunettes"):
		print("[LUNETTES] Lunettes non équipées")
		return

	if _en_recharge:
		print("[LUNETTES] En recharge !")
		return

	if _batterie <= 0.0:
		print("[LUNETTES] Batterie vide !")
		return

	_lunettes_allumees = not _lunettes_allumees

	if barre_batterie:
		barre_batterie.visible = _lunettes_allumees or _en_recharge

	_appliquer_effet_eclairage()
	print("[LUNETTES] Lunettes :", "allumées" if _lunettes_allumees else "éteintes")


func _eteindre_lunettes() -> void:
	_lunettes_allumees = false
	_appliquer_effet_eclairage()
	if barre_batterie:
		barre_batterie.visible = true  # Garder visible pendant recharge


func _appliquer_effet_eclairage() -> void:
	if not lampe:
		return

	var allume: bool = _lampe_allumee or _lunettes_allumees
	lampe.visible = allume

	if not allume:
		return

	if _lampe_allumee and _lunettes_allumees:
		lampe.spot_angle = 60.0
		lampe.light_energy = 3.5
	elif _lunettes_allumees:
		lampe.spot_angle = 60.0
		lampe.light_energy = 0.8
	else:
		lampe.spot_angle = 25.0
		lampe.light_energy = 2.0


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

	timer_node._temps_restant += 60.0
	print("[CHRONO] +60 secondes ! Temps restant : ", timer_node._temps_restant)

	var index: int = slots.find("chrono")
	EquipmentManager.equiper_slot(index, "")

	var label_timer := timer_node.get_node_or_null("LabelTimer")
	if label_timer:
		timer_node._chrono_actif = true
		label_timer.add_theme_color_override("font_color", Color(0.2, 1, 0.2))

	var hud_inventaire := get_node_or_null("HUD/HUDInventaire")
	if hud_inventaire:
		var panneau = hud_inventaire._panneaux[index]
		var label: Label = panneau.get_node("Label")
		label.add_theme_color_override("font_color", Color(1, 0.2, 0.2))

	var racine := get_tree().current_scene
	if racine and racine.has_method("afficher_succes_avec_transition"):
		racine.afficher_succes_avec_transition("⏱️ +60 secondes !", 2.0, false)

	await get_tree().create_timer(5.0).timeout

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
