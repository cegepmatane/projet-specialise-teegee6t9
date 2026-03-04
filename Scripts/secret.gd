extends Node3D

var _ramasse: bool = false

func interact() -> void:
	if _ramasse:
		return
	_ramasse = true

	const id := "find_secret"
	var nouvellement := SuccessManager.debloquer(id)
	if nouvellement:
		var racine := get_tree().current_scene
		if racine and racine.has_method("afficher_succes_avec_transition"):
			var titre := SuccessManager.obtenir_titre_succes(id)
			await racine.afficher_succes_avec_transition(
				"Succès débloqué : %s" % titre,
				2.0,
				false
			)

	# Supprimer l'objet secret après ramassage
	queue_free()
