extends Area3D

@export var duree_effet: float = 0.2
var utilise := false
@onready var forme: CollisionShape3D = $CollisionShape3D

# Clé des succès par nombre de parties
const SUCCES_PAR_NOMBRE := {
	1: "escape_first_time",
	3: "escape_3_times",
	10:"escape_10_times"
}

func _ready() -> void:
	body_entered.connect(_sur_entree_corps)

func _sur_entree_corps(corps: Node) -> void:
	if utilise:
		return

	# Vérifie si c'est bien le joueur
	var node := corps
	for i in range(4):
		if node == null:
			break
		if node.name == "Joueur" or node.is_in_group("Joueur"):
			utilise = true
			print("[DEBUG] Trigger activé par :", node.name)
			_trigger_tp_async()
			return
		node = node.get_parent()

func _trigger_tp_async() -> void:
	set_deferred("monitoring", false)
	if forme:
		forme.set_deferred("disabled", true)

	# --- Incrémenter le compteur global de parties réussies ---
	var total_parties := SuccessManager.incrementer_parties_reussies()
	print("[DEBUG] Nombre total de parties réussies =", total_parties)

	# --- Vérifier et débloquer les succès correspondants ---
	for nb in SUCCES_PAR_NOMBRE.keys():
		var id_succes : String = SUCCES_PAR_NOMBRE[nb]
		if total_parties >= nb and not SuccessManager.est_debloque(id_succes):
			SuccessManager.debloquer(id_succes)
			var racine := get_tree().current_scene
			if racine and racine.has_method("afficher_succes_avec_transition"):
				var titre := SuccessManager.obtenir_titre_succes(id_succes)
				await racine.afficher_succes_avec_transition(
					"Succès débloqué : %s" % titre,
					2.0,
					true
				)

	# --- Changer de scène après effet ---
	var timer := get_tree().create_timer(duree_effet)
	await timer.timeout
	if get_tree().current_scene != null:
		var err := get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
		if err != OK:
			push_warning("[DEBUG] Échec du changement de scène : %s" % str(err))
