extends Control

func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://save.cfg") == OK:
		var parties: int = cfg.get_value("stats", "parties_reussies", 0)
		visible = parties == 0
	else:
		visible = true
	
	_construire_liste()


func _construire_liste() -> void:
	var vbox: VBoxContainer = $PanelContainer/VBoxContainer
	
	# Vider les labels existants sauf le titre
	for enfant in vbox.get_children():
		enfant.queue_free()
	
	var titre := Label.new()
	titre.text = "🎮 Contrôles"
	vbox.add_child(titre)
	
	var actions := {
		"avancer": "Avancer",
		"reculer": "Reculer",
		"gauche": "Gauche",
		"droite": "Droite",
		"sauter": "Sauter",
		"lampe": "Lampe",
		"lunettes": "Lunettes",
		"chrono": "Chrono",
	}
	
	var hardcodes := {
		"Tab": "Carnet",
		"Clic Gauche": "Interagir",
		"Échap": "Pause"
	}
	
	for action in actions.keys():
		var touche: String = _obtenir_touche(action)
		var label := Label.new()
		label.text = "%s — %s" % [touche, actions[action]]
		vbox.add_child(label)

	for touche in hardcodes.keys():
		var label := Label.new()
		label.text = "%s — %s" % [touche, hardcodes[touche]]
		vbox.add_child(label)

func _obtenir_touche(action: String) -> String:
	var events := InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			if event.physical_keycode != 0:
				return OS.get_keycode_string(DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode))
			elif event.keycode != 0:
				return event.as_text_keycode()
		if event is InputEventMouseButton:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					return "Clic gauche"
				MOUSE_BUTTON_RIGHT:
					return "Clic droit"
	return "?"


func afficher() -> void:
	visible = true


func cacher() -> void:
	visible = false
