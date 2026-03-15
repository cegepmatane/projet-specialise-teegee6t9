extends Control

@onready var label_argent: Label = $Panel/MarginContainer/VBoxContainer/LabelArgent
@onready var liste_items: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ListeItems
@onready var label_preset1: Label = $Panel/MarginContainer/VBoxContainer/Presets/LabelPreset1
@onready var label_preset2: Label = $Panel/MarginContainer/VBoxContainer/Presets/LabelPreset2
@onready var bouton_fermer: Button = $Panel/MarginContainer/VBoxContainer/BoutonFermer


func _ready() -> void:
	bouton_fermer.pressed.connect(fermer)
	visible = false


func ouvrir() -> void:
	visible = true
	rafraichir()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func fermer() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Dire au trigger que c'est fermé
	var trigger := get_tree().current_scene.get_node_or_null("BoutonBoutique")
	if trigger:
		trigger.menu_ouvert = false


func rafraichir() -> void:
	label_argent.text = "Argent : %d$" % EquipmentManager.obtenir_argent()

	for enfant in liste_items.get_children():
		enfant.queue_free()

	for item in EquipmentManager.obtenir_tous_les_items():
		var ligne := HBoxContainer.new()

		var nom := Label.new()
		nom.text = "%s  (%d/%d)" % [item["nom"], item["quantite"], item["stack_max"]]
		nom.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		ligne.add_child(nom)

		var prix := Label.new()
		prix.text = "%d$" % item["prix"]
		prix.custom_minimum_size.x = 55
		ligne.add_child(prix)

		var bouton := Button.new()
		bouton.text = "Acheter"
		bouton.disabled = not item["peut_acheter"]
		var id_capture: String = item["id"]
		bouton.pressed.connect(func(): _acheter(id_capture))
		ligne.add_child(bouton)

		liste_items.add_child(ligne)

	_rafraichir_presets()


func _rafraichir_presets() -> void:
	label_preset1.text = "Preset 1 : " + _format_preset(EquipmentManager.obtenir_preset("preset_1"))
	label_preset2.text = "Preset 2 : " + _format_preset(EquipmentManager.obtenir_preset("preset_2"))


func _format_preset(slots: Array) -> String:
	var noms: Array = []
	for id in slots:
		noms.append(id if id != "" else "vide")
	return ", ".join(noms)


func _acheter(id: String) -> void:
	EquipmentManager.acheter(id)
	rafraichir()
