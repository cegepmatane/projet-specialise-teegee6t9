extends CanvasLayer

var _actif: bool = false

@onready var panneau: Control = $Panneau
@onready var btn_reprendre: Button = $Panneau/VBox/BtnReprendre
@onready var btn_lobby: Button = $Panneau/VBox/BtnLobby
@onready var btn_quitter: Button = $Panneau/VBox/BtnQuitter


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	btn_reprendre.pressed.connect(reprendre)
	btn_lobby.pressed.connect(_aller_lobby)
	btn_quitter.pressed.connect(_quitter)
	panneau.visible = false
	
	if get_tree().current_scene.name == "lobby":
		btn_lobby.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Échap
		if _actif:
			reprendre()
		else:
			pauser()


func pauser() -> void:
	_actif = true
	panneau.visible = true
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
