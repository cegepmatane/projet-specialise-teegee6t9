extends Node

func afficher_succes(id_succes: String, utiliser_ecran_chargement: bool = false) -> void:
	var root := get_tree().current_scene
	if root == null:
		return

	# Cherche une instance de success_ui.tscn (CanvasLayer avec notre script)
	# Si tu renomme l'instance "SuccessUI" dans l'arbre, tu peux la chercher par nom.
	var ui := root.get_node_or_null("SuccessUI")
	if ui == null:
		# Si l'instance est directement un CanvasLayer sans renommage
		ui = root.get_node_or_null("CanvasLayer")

	if ui and ui.has_method("afficher_succes_avec_transition"):
		var titre := SuccessManager.obtenir_titre_succes(id_succes)
		await ui.afficher_succes_avec_transition(
			"Succès débloqué : %s" % titre,
			2.0,
			utiliser_ecran_chargement
		)
