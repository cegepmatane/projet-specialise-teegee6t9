extends HBoxContainer

const COULEUR_ACTIF := Color(1, 1, 1, 1)
const COULEUR_INACTIF := Color(0.6, 0.6, 0.6, 1)

var _slot_actif: int = 0
var _panneaux: Array = []


func _ready() -> void:
	_construire_slots()
	rafraichir()


func _construire_slots() -> void:
	for i in range(3):
		var panneau := PanelContainer.new()
		panneau.custom_minimum_size = Vector2(120, 50)

		var label := Label.new()
		label.name = "Label"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_color", COULEUR_INACTIF)
		panneau.add_child(label)

		add_child(panneau)
		_panneaux.append(panneau)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slot_1"):
		_selectionner_slot(0)
	elif event.is_action_pressed("slot_2"):
		_selectionner_slot(1)
	elif event.is_action_pressed("slot_3"):
		_selectionner_slot(2)


func _selectionner_slot(index: int) -> void:
	_slot_actif = index
	rafraichir()
	print("[HUD] Slot actif : ", index + 1, " → ", EquipmentManager.obtenir_slot(index))


func rafraichir() -> void:
	var slots: Array = EquipmentManager.obtenir_slots_actifs()
	for i in range(_panneaux.size()):
		var label: Label = _panneaux[i].get_node("Label")
		var id: String = slots[i]
		var actif: bool = i == _slot_actif

		if id == "":
			label.text = "[%d] vide" % (i + 1)
		else:
			var qte: int = EquipmentManager.obtenir_quantite(id)
			label.text = "[%d] %s (%d)" % [i + 1, id, qte]

		label.add_theme_color_override(
			"font_color",
			COULEUR_ACTIF if actif else COULEUR_INACTIF
		)
