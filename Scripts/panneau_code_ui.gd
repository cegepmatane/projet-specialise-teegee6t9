extends Control

var _panneau: Node = null

@onready var slots_couleurs: HBoxContainer = $Panel/VBox/Couleurs/Slots
@onready var boutons_couleurs: HBoxContainer = $Panel/VBox/Couleurs/Boutons
@onready var slots_chiffres: HBoxContainer = $Panel/VBox/Chiffres/Slots
@onready var boutons_chiffres: HBoxContainer = $Panel/VBox/Chiffres/Boutons
@onready var label_erreur: Label = $Panel/VBox/LabelErreur
@onready var bouton_fermer: Button = $Panel/VBox/BoutonFermer


func _ready() -> void:
	bouton_fermer.pressed.connect(fermer)
	visible = false


var _interface_construite: bool = false

func ouvrir(panneau: Node) -> void:
	_panneau = panneau
	visible = true
	label_erreur.text = ""
	if not _interface_construite:
		_construire_interface()
		_interface_construite = true
	_sync_slots()


func fermer() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if _panneau:
		_panneau._ouvert = false


func _construire_interface() -> void:
	# Slots couleurs
	for enfant in slots_couleurs.get_children():
		enfant.queue_free()
	for i in range(5):
		var slot := ColorRect.new()
		slot.custom_minimum_size = Vector2(40, 40)
		slot.color = Color(0.3, 0.3, 0.3)
		slots_couleurs.add_child(slot)

	# Boutons couleurs
	for enfant in boutons_couleurs.get_children():
		enfant.queue_free()
	for nom_couleur in _panneau.obtenir_couleurs().keys():
		var btn := Button.new()
		btn.text = nom_couleur
		btn.custom_minimum_size = Vector2(70, 35)
		var c: String = nom_couleur
		btn.pressed.connect(func(): _sur_couleur(c))
		boutons_couleurs.add_child(btn)

	# Bouton effacer couleurs
	var btn_eff_c := Button.new()
	btn_eff_c.text = "⌫ Effacer"
	btn_eff_c.pressed.connect(_effacer_couleurs)
	boutons_couleurs.add_child(btn_eff_c)

	# Slots chiffres
	for enfant in slots_chiffres.get_children():
		enfant.queue_free()
	for i in range(5):
		var slot := Label.new()
		slot.text = "_"
		slot.custom_minimum_size = Vector2(35, 35)
		slot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slots_chiffres.add_child(slot)

	# Boutons chiffres
	for enfant in boutons_chiffres.get_children():
		enfant.queue_free()
	for i in range(10):
		var btn := Button.new()
		btn.text = str(i)
		btn.custom_minimum_size = Vector2(40, 35)
		var n: int = i
		btn.pressed.connect(func(): _sur_chiffre(n))
		boutons_chiffres.add_child(btn)

	# Bouton effacer chiffres
	var btn_eff_n := Button.new()
	btn_eff_n.text = "⌫ Effacer"
	btn_eff_n.custom_minimum_size = Vector2(80, 35)
	btn_eff_n.pressed.connect(_effacer_chiffres)
	boutons_chiffres.add_child(btn_eff_n)


func _sync_slots() -> void:
	# Resynchronise l'affichage avec l'état actuel du panneau
	for i in range(5):
		var slot_c: ColorRect = slots_couleurs.get_child(i)
		var id_c: String = _panneau._entree_couleurs[i]
		if id_c != "":
			slot_c.color = _panneau.obtenir_couleurs()[id_c]
		else:
			slot_c.color = Color(0.3, 0.3, 0.3)

		var slot_n: Label = slots_chiffres.get_child(i)
		var val_n: int = _panneau._entree_chiffres[i]
		if val_n >= 0:
			slot_n.text = str(val_n)
		else:
			slot_n.text = "_"


func _sur_couleur(couleur: String) -> void:
	if _panneau._slot_couleur_actif >= 5:
		return
	var slot: ColorRect = slots_couleurs.get_child(_panneau._slot_couleur_actif)
	slot.color = _panneau.obtenir_couleurs()[couleur]
	_panneau.soumettre_couleur(couleur)


func _sur_chiffre(chiffre: int) -> void:
	if _panneau._slot_chiffre_actif >= 5:
		return
	var slot: Label = slots_chiffres.get_child(_panneau._slot_chiffre_actif)
	slot.text = str(chiffre)
	_panneau.soumettre_chiffre(chiffre)


func _effacer_couleurs() -> void:
	_panneau.effacer_couleurs()
	for slot in slots_couleurs.get_children():
		if slot is ColorRect:
			slot.color = Color(0.3, 0.3, 0.3)
	label_erreur.text = ""


func _effacer_chiffres() -> void:
	_panneau.effacer_chiffres()
	for slot in slots_chiffres.get_children():
		if slot is Label:
			slot.text = "_"
	label_erreur.text = ""


func afficher_erreur(couleurs_ok: bool, chiffres_ok: bool) -> void:
	if not couleurs_ok and not chiffres_ok:
		label_erreur.text = "❌ Les deux codes sont incorrects"
	elif not couleurs_ok:
		label_erreur.text = "❌ Code couleurs incorrect"
	else:
		label_erreur.text = "❌ Code chiffres incorrect"
	label_erreur.add_theme_color_override("font_color", Color(1, 0.2, 0.2))
