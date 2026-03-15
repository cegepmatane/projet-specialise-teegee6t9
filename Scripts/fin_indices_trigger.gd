extends Area3D

@export var prochaine_scene: String = "res://Scenes/lobby.tscn"
@export var duree_effet: float = 0.2
var utilise: bool = false

@onready var forme: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	print("[DEBUG] FinIndices prêt, monitoring=", monitoring, " mask=", collision_mask, " layer=", collision_layer)
	body_entered.connect(_sur_entree_corps)


func _sur_entree_corps(corps: Node) -> void:
	print("[DEBUG] body_entered par : ", corps, " (name=", corps.name, ")")
	if utilise:
		print("[DEBUG] déjà utilisé, on ignore")
		return

	var node: Node = corps
	for i in range(4):
		if node == null:
			break

		print("[DEBUG] test node=", node.name, " i=", i)

		if node.name == "Joueur" or node.is_in_group("Joueur"):
			utilise = true
			print("[DEBUG] Trigger téléporteur activé par : ", node.name)
			_trigger_tp_async()
			return

		if node is Node:
			node = node.get_parent()
		else:
			break


func _trigger_tp_async() -> void:
	set_deferred("monitoring", false)
	if forme:
		forme.set_deferred("disabled", true)

	# Gagner l'argent de la partie
	EquipmentManager.gagner_argent_partie()

	var nouveaux: Array = SuccessManager.incrementer_et_verifier()
	print("[DEBUG] Parties réussies =", SuccessManager.obtenir_parties_reussies())
	for id in nouveaux:
		var racine := get_tree().current_scene
		if racine and racine.has_method("afficher_succes_avec_transition"):
			var titre: String = SuccessManager.obtenir_titre_succes(id)
			await racine.afficher_succes_avec_transition(
				"Succès débloqué : %s" % titre,
				2.0,
				true
			)

	var timer := get_tree().create_timer(duree_effet)
	await timer.timeout
	if prochaine_scene != "":
		get_tree().change_scene_to_file(prochaine_scene)
