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

	# Collecter tous les nouveaux succès
	var tous_nouveaux: Array = []

	# Argent gagné
	var argent_avant: int = EquipmentManager.obtenir_argent()
	var nouveaux_argent := SuccessManager.verifier_succes_argent(argent_avant + EquipmentManager.GAIN_PARTIE)
	EquipmentManager.gagner_argent_partie()
	var argent_gagne: int = EquipmentManager.obtenir_argent() - argent_avant
	tous_nouveaux.append_array(nouveaux_argent)

	# Temps écoulé
	var temps_ecoule: float = 0.0
	var timer_node: Node = null
	var joueurs := get_tree().get_nodes_in_group("Joueur")
	if joueurs.size() > 0:
		timer_node = joueurs[0].get_node_or_null("HUD/TimerPartie")
		print("[DEBUG] Joueur trouvé : ", joueurs[0].name)
	else:
		print("[DEBUG] Aucun joueur dans le groupe Joueur")

	if timer_node:
		temps_ecoule = timer_node.duree_secondes - timer_node._temps_restant
		print("[DEBUG] Temps écoulé : %.1f secondes" % temps_ecoule)
		timer_node._actif = false
	else:
		print("[DEBUG] TimerPartie introuvable")

	# Succès temps
	var nouveaux_temps := SuccessManager.verifier_succes_temps_ecoule(temps_ecoule)
	tous_nouveaux.append_array(nouveaux_temps)

	# Partie parfaite
	var secret_trouve: bool = IndiceManager._secret_trouve
	var tous_indices: bool = IndiceManager.obtenir_nombre_trouves() >= IndiceManager.obtenir_nombre_total()
	print("[DEBUG] Secret trouvé : ", secret_trouve, " | Tous indices : ", tous_indices)
	if secret_trouve and tous_indices:
		print("[DEBUG] Partie parfaite !")
		var nouveaux_parfaits := SuccessManager.incrementer_partie_parfaite_et_verifier()
		tous_nouveaux.append_array(nouveaux_parfaits)

	# Succès parties réussies
	var nouveaux: Array = SuccessManager.incrementer_et_verifier()
	tous_nouveaux.append_array(nouveaux)
	print("[DEBUG] Parties réussies =", SuccessManager.obtenir_parties_reussies())
	
	# Vérifier succès sans équipement
	if EquipmentManager.obtenir_active_preset() == "":
		if SuccessManager.debloquer("no_equipment"):
			tous_nouveaux.append("no_equipment")
			SuccessManager.sauver_sur_disque()

	# Afficher l'écran de résultats
	var racine := get_tree().current_scene
	var ecran := racine.get_node_or_null("CanvasLayer/EcranResultats")
	if ecran:
		ecran.afficher(temps_ecoule, argent_gagne, tous_nouveaux)
	else:
		print("[DEBUG] EcranResultats introuvable, retour direct au lobby")
		var timer := get_tree().create_timer(duree_effet)
		await timer.timeout
		if prochaine_scene != "":
			get_tree().change_scene_to_file(prochaine_scene)
