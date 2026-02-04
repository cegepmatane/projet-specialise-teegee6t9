extends Area3D

const ACHIEVEMENT_ID := "escape_first_time"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Joueur":

		print("Succès débloqué : ", ACHIEVEMENT_ID)
		get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
