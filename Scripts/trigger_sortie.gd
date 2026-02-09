extends Area3D

const ACHIEVEMENT_ID := "escape_first_time"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Joueur":
		_handle_exit_sequence()

func _handle_exit_sequence() -> void:
	SuccessManager.unlock_escape_first_time()
	
	var root = get_tree().current_scene
	if root.has_method("show_success_with_transition"):
		await root.show_success_with_transition(
			"Succès débloqué : \nS'échapper pour la première fois", 2.0
		)

	get_tree().call_deferred("change_scene_to_file", "res://Scenes/lobby.tscn")
