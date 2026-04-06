extends CanvasLayer

var _actif: bool = false

@onready var panneau: Control = $Panneau
@onready var btn_reprendre: Button = $Panneau/VBox/BtnReprendre
@onready var btn_lobby: Button = $Panneau/VBox/BtnLobby
@onready var btn_quitter: Button = $Panneau/VBox/BtnQuitter
@onready var slider_volume: HSlider = $Panneau/VBox/HBoxContainer/SliderVolume

const VOLUME_BASE_LOBBY := -15.0
const VOLUME_BASE_JEU := -20.0
const OFFSET_MAX := 15.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	btn_reprendre.pressed.connect(reprendre)
	btn_lobby.pressed.connect(_aller_lobby)
	btn_quitter.pressed.connect(_quitter)
	panneau.visible = false
	
	# Charger les volumes sauvegardés
	var cfg := ConfigFile.new()
	if cfg.load("user://save.cfg") == OK:
		slider_volume.value = cfg.get_value("audio", "volume", 50)
	else:
		slider_volume.value = 50
		
	slider_volume.value_changed.connect(_sur_changement_volume)
	_sur_changement_volume(slider_volume.value)

	if get_tree().current_scene.name == "lobby":
		btn_lobby.visible = false
		btn_reprendre.text = "Fermer"


func _sur_changement_volume(valeur: float) -> void:
	var offset: float = (valeur - 50.0) / 50.0 * OFFSET_MAX
	var bus_lobby := AudioServer.get_bus_index("Lobby")
	var bus_jeu := AudioServer.get_bus_index("Jeu")
	AudioServer.set_bus_volume_db(bus_lobby, VOLUME_BASE_LOBBY + offset)
	AudioServer.set_bus_volume_db(bus_jeu, VOLUME_BASE_JEU + offset)
	
	var cfg := ConfigFile.new()
	cfg.load("user://save.cfg")
	cfg.set_value("audio", "volume", valeur)
	cfg.save("user://save.cfg")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var racine := get_tree().current_scene
		var panneau_ui := racine.get_node_or_null("CanvasLayer/PanneauCodeUI")
		if panneau_ui and panneau_ui.visible:
			return
		if _actif:
			reprendre()
		else:
			pauser()


func pauser() -> void:
	_actif = true
	panneau.visible = true
	# Ne pas pauser dans le lobby pour garder la musique audible
	if get_tree().current_scene.name != "lobby":
		get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func reprendre() -> void:
	_actif = false
	panneau.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _aller_lobby() -> void:
	if get_tree().current_scene.name == "lobby":
		reprendre()
		return
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	var tween := get_tree().create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1), 0.5)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://Scenes/lobby.tscn"))


func _quitter() -> void:
	get_tree().quit()
