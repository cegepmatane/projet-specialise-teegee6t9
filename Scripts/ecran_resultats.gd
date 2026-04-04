extends CanvasLayer

@onready var label_temps: Label = $Panneau/VBox/LabelTemps
@onready var label_argent: Label = $Panneau/VBox/LabelArgent
@onready var liste_succes: VBoxContainer = $Panneau/VBox/ListeSucces
@onready var bouton_continuer: Button = $Panneau/VBox/BoutonContinuer
@onready var overlay: ColorRect = $Overlay


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	bouton_continuer.pressed.connect(_aller_lobby)
	visible = false


func afficher(temps_ecoule: float, argent_gagne: int, nouveaux_succes: Array) -> void:
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Temps
	var minutes: int = int(temps_ecoule / 60.0)
	var secondes: int = int(temps_ecoule) % 60
	label_temps.text = "⏱️ Temps : %02d:%02d" % [minutes, secondes]

	# Argent
	label_argent.text = "💰 Argent gagné : +%d$" % argent_gagne

	# Succès débloqués
	for enfant in liste_succes.get_children():
		enfant.queue_free()

	if nouveaux_succes.is_empty():
		var label := Label.new()
		label.text = "Aucun nouveau succès"
		label.modulate = Color(0.6, 0.6, 0.6)
		liste_succes.add_child(label)
	else:
		for id in nouveaux_succes:
			var label := Label.new()
			label.text = "🏆 %s" % SuccessManager.obtenir_titre_succes(id)
			label.add_theme_color_override("font_color", Color(1, 0.85, 0.2))
			liste_succes.add_child(label)

	# Lancer les notifications ET le fade en parallèle
	_afficher_notifications(nouveaux_succes)

	overlay.color = Color(0, 0, 0, 0)
	var tween := create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0.85), 0.5)


func _afficher_notifications(nouveaux_succes: Array) -> void:
	get_tree().paused = false
	for id in nouveaux_succes:
		var titre: String = SuccessManager.obtenir_titre_succes(id)
		var racine := get_tree().current_scene
		if racine and racine.has_method("afficher_succes_avec_transition"):
			await racine.afficher_succes_avec_transition(
				"Succès débloqué : %s" % titre,
				2.0,
				false
			)
	get_tree().paused = true


func _aller_lobby() -> void:
	get_tree().paused = false
	var tween := create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1), 0.5)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://Scenes/lobby.tscn"))
