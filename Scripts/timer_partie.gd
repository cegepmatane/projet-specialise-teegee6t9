extends Control

@export var duree_secondes: float = 20.0

var _temps_restant: float = 0.0
var _actif: bool = false
var _echec_en_cours: bool = false

@onready var label_timer: Label = $LabelTimer


func _ready() -> void:
	_temps_restant = duree_secondes
	_actif = true


func _process(delta: float) -> void:
	if not _actif:
		return

	_temps_restant -= delta

	if _temps_restant <= 0.0:
		_temps_restant = 0.0
		_actif = false
		if not _echec_en_cours:
			_echec_en_cours = true
			_sur_echec()

	_mettre_a_jour_affichage()


func _mettre_a_jour_affichage() -> void:
	var minutes: int = int(_temps_restant) / 60
	var secondes: int = int(_temps_restant) % 60
	label_timer.text = "%02d:%02d" % [minutes, secondes]

	if _temps_restant <= 30.0:
		label_timer.add_theme_color_override("font_color", Color(1, 0, 0))
	else:
		label_timer.add_theme_color_override("font_color", Color(1, 1, 1))


func _sur_echec() -> void:
	print("[TIMER] Temps écoulé — échec de la mission")
	EquipmentManager.reset_on_failure()
	_afficher_ecran_defaite()


func _afficher_ecran_defaite() -> void:
	# Créer un overlay noir par-dessus tout
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	get_tree().current_scene.add_child(overlay)

	var label := Label.new()
	label.text = "Mission échouée\nVous retournez au lobby..."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_color_override("font_color", Color(1, 0.2, 0.2))
	overlay.add_child(label)

	# Fade in
	var tween := get_tree().create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1), 0.8)
	tween.tween_interval(2.0)
	tween.tween_callback(
		func(): get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
	)
