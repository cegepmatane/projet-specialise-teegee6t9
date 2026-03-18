extends Control

@onready var label_argent: Label = $Panel/MarginContainer/VBoxContainer/LabelArgent
@onready var liste_items: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ListeItems
@onready var bouton_fermer: Button = $Panel/MarginContainer/VBoxContainer/BoutonFermer

var _slot_selectionne: int = -1
var _preset_actif_ui: String = "preset_1"
var _labels_slots: Dictionary = {}
var _boutons_activer: Dictionary = {}


func _ready() -> void:
	bouton_fermer.pressed.connect(fermer)
	visible = false


func ouvrir() -> void:
	visible = true
	rafraichir()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func fermer() -> void:
	visible = false
	_slot_selectionne = -1
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var trigger := get_tree().current_scene.get_node_or_null("BoutonBoutique")
	if trigger:
		trigger.menu_ouvert = false


func rafraichir() -> void:
	label_argent.text = "Argent : %d$" % EquipmentManager.obtenir_argent()
	_rafraichir_items()
	_rafraichir_presets()


# ─────────────────────────────────────────
#  SECTION ITEMS
# ─────────────────────────────────────────

func _rafraichir_items() -> void:
	for enfant in liste_items.get_children():
		enfant.queue_free()

	for item in EquipmentManager.obtenir_tous_les_items():
		var ligne := HBoxContainer.new()

		var nom := Label.new()
		nom.text = "%s (%d/%d)" % [item["nom"], item["quantite"], item["stack_max"]]
		nom.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		ligne.add_child(nom)

		var prix := Label.new()
		prix.text = "%d$" % item["prix"]
		prix.custom_minimum_size.x = 50
		ligne.add_child(prix)

		var btn_acheter := Button.new()
		btn_acheter.text = "Acheter"
		btn_acheter.disabled = not item["peut_acheter"]
		var id_achat: String = item["id"]
		btn_acheter.pressed.connect(func(): _acheter(id_achat))
		ligne.add_child(btn_acheter)

		var btn_plus := Button.new()
		btn_plus.text = "+"
		btn_plus.custom_minimum_size.x = 30
		btn_plus.disabled = item["quantite"] == 0
		var id_assign: String = item["id"]
		btn_plus.pressed.connect(func(): _assigner_item(id_assign))
		ligne.add_child(btn_plus)

		var btn_moins := Button.new()
		btn_moins.text = "-"
		btn_moins.custom_minimum_size.x = 30
		var id_retirer: String = item["id"]
		btn_moins.pressed.connect(func(): _retirer_item(id_retirer))
		ligne.add_child(btn_moins)

		liste_items.add_child(ligne)


func _acheter(id: String) -> void:
	EquipmentManager.acheter(id)
	rafraichir()


func _assigner_item(id: String) -> void:
	var preset: Array = EquipmentManager.obtenir_preset(_preset_actif_ui)
	if _slot_selectionne < 0:
		for i in range(preset.size()):
			if preset[i] == "":
				_slot_selectionne = i
				break
		if _slot_selectionne < 0:
			_slot_selectionne = 0

	preset[_slot_selectionne] = id
	EquipmentManager.enregistrer_preset(_preset_actif_ui, preset)
	_slot_selectionne = -1
	_rafraichir_presets()


func _retirer_item(id: String) -> void:
	var preset: Array = EquipmentManager.obtenir_preset(_preset_actif_ui)
	for i in range(preset.size()):
		if preset[i] == id:
			preset[i] = ""
			break
	EquipmentManager.enregistrer_preset(_preset_actif_ui, preset)
	_rafraichir_presets()


# ─────────────────────────────────────────
#  SECTION PRESETS
# ─────────────────────────────────────────

func _rafraichir_presets() -> void:
	var vbox: VBoxContainer = $Panel/MarginContainer/VBoxContainer
	var section_presets: Node = vbox.get_node_or_null("SectionPresets")

	if section_presets == null:
		_construire_section_presets(vbox)
	else:
		_mettre_a_jour_labels_presets()


func _construire_section_presets(vbox: VBoxContainer) -> void:
	var sep := HSeparator.new()
	vbox.add_child(sep)
	vbox.move_child(sep, vbox.get_child_count() - 2)

	var section := VBoxContainer.new()
	section.name = "SectionPresets"
	vbox.add_child(section)
	vbox.move_child(section, vbox.get_child_count() - 2)

	var titre := Label.new()
	titre.text = "── Présélections ──"
	titre.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	section.add_child(titre)

	for nom_preset in ["preset_1", "preset_2"]:
		var bloc := VBoxContainer.new()
		bloc.name = nom_preset
		section.add_child(bloc)

		var label_titre := Label.new()
		label_titre.text = "Preset %s" % ("1" if nom_preset == "preset_1" else "2")
		bloc.add_child(label_titre)

		var ligne_slots := HBoxContainer.new()
		bloc.add_child(ligne_slots)

		var labels: Array = []
		for i in range(3):
			var slot_btn := Button.new()
			slot_btn.custom_minimum_size.x = 80
			var preset_capture: String = nom_preset
			var slot_capture: int = i
			slot_btn.pressed.connect(func(): _selectionner_slot(preset_capture, slot_capture))
			ligne_slots.add_child(slot_btn)
			labels.append(slot_btn)

		_labels_slots[nom_preset] = labels

		var btn_activer := Button.new()
		var actif: String = EquipmentManager.obtenir_active_preset()
		btn_activer.text = "✓ Actif" if actif == nom_preset else "Activer"
		var preset_act: String = nom_preset
		btn_activer.pressed.connect(func(): _activer_preset(preset_act))
		bloc.add_child(btn_activer)
		_boutons_activer[nom_preset] = btn_activer

	_mettre_a_jour_labels_presets()


func _mettre_a_jour_labels_presets() -> void:
	var actif: String = EquipmentManager.obtenir_active_preset()

	for nom_preset in ["preset_1", "preset_2"]:
		if not _labels_slots.has(nom_preset):
			continue

		var preset: Array = EquipmentManager.obtenir_preset(nom_preset)
		var labels: Array = _labels_slots[nom_preset]

		for i in range(labels.size()):
			var id: String = preset[i] if i < preset.size() else ""
			var btn: Button = labels[i]
			btn.text = "[%d] %s" % [i + 1, id if id != "" else "vide"]
			btn.modulate = Color(1, 1, 0) if (_preset_actif_ui == nom_preset and _slot_selectionne == i) else Color(1, 1, 1)

		if _boutons_activer.has(nom_preset):
			_boutons_activer[nom_preset].text = "✓ Actif" if actif == nom_preset else "Activer"


func _selectionner_slot(nom_preset: String, slot: int) -> void:
	_preset_actif_ui = nom_preset
	_slot_selectionne = slot
	_mettre_a_jour_labels_presets()


func _activer_preset(nom: String) -> void:
	if EquipmentManager.obtenir_active_preset() == nom:
		# Déjà actif — désactiver
		EquipmentManager.desactiver_preset()
	else:
		EquipmentManager.appliquer_preset(nom)
	_mettre_a_jour_labels_presets()
