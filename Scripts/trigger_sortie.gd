extends Area3D

var utilise := false
@onready var forme: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	body_entered.connect(_sur_entree_corps)

func _sur_entree_corps(corps: Node) -> void:
	if utilise:
		return
	if corps.name == "Joueur":
		utilise = true

		set_deferred("monitoring", false)
		if forme:
			forme.set_deferred("disabled", true)
		await _gerer_sequence_sortie()

func _gerer_sequence_sortie() -> void:
	const id := "escape_first_time"
	var nouvellement := SuccessManager.debloquer(id)
	if nouvellement:
		var racine := get_tree().current_scene
		if racine and racine.has_method("afficher_succes_avec_transition"):
			var titre := SuccessManager.obtenir_titre_succes(id)
			await racine.afficher_succes_avec_transition("Succès débloqué : %s" % titre, 2.0, true)

	get_tree().call_deferred("change_scene_to_file", "res://Scenes/lobby.tscn")
