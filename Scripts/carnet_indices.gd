extends Control

var _ouvert: bool = false


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):  # Tab
		if _ouvert:
			fermer()
		else:
			ouvrir()


func ouvrir() -> void:
	_ouvert = true
	visible = true
	rafraichir()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func fermer() -> void:
	_ouvert = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func rafraichir() -> void:
	var couleurs: VBoxContainer = $Panel/HBox/Couleurs/Liste
	var chiffres: VBoxContainer = $Panel/HBox/Chiffres/Liste

	# Vider
	for enfant in couleurs.get_children():
		enfant.queue_free()
	for enfant in chiffres.get_children():
		enfant.queue_free()

	# Remplir couleurs
	for i in range(5):
		var label := Label.new()
		var id := "couleur_%d" % (i + 1)
		if IndiceManager._indices_ramasses.has(id):
			var couleur: String = IndiceManager.code_couleurs[i]
			label.text = "Couleur %d : %s" % [i + 1, couleur]
			label.add_theme_color_override("font_color", Color(0.2, 1, 0.2))
		else:
			label.text = "Couleur %d : ???" % (i + 1)
			label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		couleurs.add_child(label)

	# Remplir chiffres
	for i in range(5):
		var label := Label.new()
		var id := "chiffre_%d" % (i + 1)
		if IndiceManager._indices_ramasses.has(id):
			var chiffre: int = IndiceManager.code_chiffres[i]
			label.text = "Chiffre %d : %d" % [i + 1, chiffre]
			label.add_theme_color_override("font_color", Color(0.2, 1, 0.2))
		else:
			label.text = "Chiffre %d : ???" % (i + 1)
			label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		chiffres.add_child(label)
