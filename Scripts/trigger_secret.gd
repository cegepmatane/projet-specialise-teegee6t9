extends Area3D

## Débloque le succès "Trouver le secret" quand le joueur entre dans la zone.

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
		await _handle_secret_found()

func _handle_secret_found() -> void:
	const id := "find_secret"
	var newly := SuccessManager.unlock(id)
	if newly:
		var root := get_tree().current_scene
		if root and root.has_method("show_success_with_transition"):
			var titre := SuccessManager.get_success_title(id)
			await root.show_success_with_transition("Succès débloqué : %s" % titre, 2.0, false)  # popup seule, pas d'écran blanc
