extends Area3D

@export var duree_effet: float = 0.2
var utilise := false

@onready var forme: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	body_entered.connect(_sur_entree_corps)


func _sur_entree_corps(corps: Node) -> void:

	if utilise:
		return

	var node := corps

	for i in range(4):

		if node == null:
			break

		if node.name == "Joueur" or node.is_in_group("Joueur"):

			utilise = true

			_trigger_tp_async()

			return

		node = node.get_parent()


func _trigger_tp_async() -> void:

	set_deferred("monitoring", false)

	if forme:
		forme.set_deferred("disabled", true)

	var nouveaux = SuccessManager.incrementer_et_verifier()

	for id in nouveaux:

		var racine := get_tree().current_scene

		if racine and racine.has_method("afficher_succes_avec_transition"):

			var titre = SuccessManager.obtenir_titre_succes(id)

			await racine.afficher_succes_avec_transition(
				"Succès débloqué : %s" % titre,
				2.0,
				true
			)

	var timer := get_tree().create_timer(duree_effet)

	await timer.timeout

	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
