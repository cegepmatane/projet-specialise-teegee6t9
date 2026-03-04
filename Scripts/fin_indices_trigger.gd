extends Area3D

@export var prochaine_scene: String = "res://Scenes/lobby.tscn"
@export var duree_effet: float = 0.2
var utilise: bool = false

@onready var forme: CollisionShape3D = $CollisionShape3D

const SUCCES_ESCAPE_FIRST := "escape_first_time"

func _ready() -> void:
	print("[DEBUG] FinIndices prêt, monitoring=", monitoring, " mask=", collision_mask, " layer=", collision_layer)
	body_entered.connect(_sur_entree_corps)


func _sur_entree_corps(corps: Node) -> void:
	print("[DEBUG] body_entered par : ", corps, " (name=", corps.name, ")")
	if utilise:
		print("[DEBUG] déjà utilisé, on ignore")
		return

	var node: Node = corps
	for i in range(4): # remonter les parents pour vérifier si c'est le joueur
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

	# 🔥 Incrémentation du compteur
	var total_parties := SuccessManager.incrementer_parties_reussies()
	print("[DEBUG] Parties réussies =", total_parties)

	# Succès première évasion
	if total_parties == 1:
		var nouvellement := SuccessManager.debloquer(SUCCES_ESCAPE_FIRST)
		if nouvellement:
			var racine := get_tree().current_scene
			if racine and racine.has_method("afficher_succes_avec_transition"):
				var titre := SuccessManager.obtenir_titre_succes(SUCCES_ESCAPE_FIRST)
				await racine.afficher_succes_avec_transition(
					"Succès débloqué : %s" % titre,
					2.0,
					true
				)

	var timer := get_tree().create_timer(duree_effet)
	await timer.timeout

	if prochaine_scene != "":
		get_tree().change_scene_to_file(prochaine_scene)
