extends Area3D

var consumed := false
@onready var shape: CollisionShape3D = $CollisionShape3D  

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if consumed:
		return
	if body.name == "Joueur":
		consumed = true
		
		set_deferred("monitoring", false)
		if shape:
			shape.set_deferred("disabled", true)
		await _handle_exit_sequence()

func _handle_exit_sequence() -> void:
	var newly := SuccessManager.unlock_escape_first_time()
	if newly:
		var root := get_tree().current_scene
		if root and root.has_method("show_success_with_transition"):
			await root.show_success_with_transition("Succès débloqué : S'échapper pour la première fois", 2.0)

	get_tree().call_deferred("change_scene_to_file", "res://Scenes/lobby.tscn")
