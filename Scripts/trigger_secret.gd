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
		await _gerer_secret_trouve()

func _gerer_secret_trouve() -> void:
	const id := "find_secret"
	var nouvellement := SuccessManager.debloquer(id)
	if nouvellement:
		var racine := get_tree().current_scene
		if racine and racine.has_method("afficher_succes_avec_transition"):
			var titre := SuccessManager.obtenir_titre_succes(id)
			await racine.afficher_succes_avec_transition("Succès débloqué : %s" % titre, 2.0, false)
