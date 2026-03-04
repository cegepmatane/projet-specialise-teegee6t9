extends Node

# 🔹 Gestion des indices pour UNE partie
var _prochain_id: int = 1
var _indices_total: int = 3
var _indices_ramasses: Dictionary = {} # id -> true

# 🔹 Scène du téléporteur de fin
var scene_fin_indices: PackedScene = preload("res://Scenes/fin_indices.tscn")

# 🔹 Chemin vers le Marker3D de fin dans la scène principale
var chemin_marker_fin: NodePath = NodePath("Structure/SalleCentrale/PointFinIndices")

# 🔹 Booléen pour éviter de spawn plusieurs fois
var _fin_spawn: bool = false


# -----------------------
# API de partie
# -----------------------

func reset_partie(indices_total: int = 3) -> void:
	# Remet complètement à zéro l'état de la partie courante
	_prochain_id = 1
	_indices_total = indices_total
	_indices_ramasses.clear()
	_fin_spawn = false
	print("[DEBUG][IndiceManager] reset_partie -> total =", _indices_total)


func enregistrer_indice() -> String:
	# Retourne un ID unique pour un nouvel indice (à stocker sur l'objet)
	var id := "indice_%d" % _prochain_id
	_prochain_id += 1
	return id


func ramasser_indice(id_indice: String) -> void:
	if id_indice == "":
		return
	if _indices_ramasses.has(id_indice):
		return

	_indices_ramasses[id_indice] = true
	print("[DEBUG][IndiceManager] Indice ramassé :", id_indice,
		" (", obtenir_nombre_trouves(), "/", _indices_total, ")")

	# Si tous les indices sont ramassés, on spawn le téléporteur
	if not _fin_spawn and obtenir_nombre_trouves() >= _indices_total:
		_fin_spawn = true
		print("[DEBUG][IndiceManager] Tous les indices ramassés, spawn téléporteur de fin")
		call_deferred("_spawn_fin_indices")


func obtenir_nombre_trouves() -> int:
	return _indices_ramasses.size()


func obtenir_nombre_total() -> int:
	return _indices_total


# -----------------------
# Spawn du téléporteur de fin + gestion lumière
# -----------------------
func _spawn_fin_indices() -> void:
	if scene_fin_indices == null:
		push_warning("IndiceManager: scene_fin_indices n'est pas assignée")
		return

	var racine := get_tree().current_scene
	if racine == null or not racine.is_inside_tree():
		push_warning("IndiceManager: aucune scène courante pour spawn la fin")
		return

	var marker := racine.get_node_or_null(chemin_marker_fin)
	if marker == null or not (marker is Node3D) or not marker.is_inside_tree():
		push_warning("IndiceManager: Marker de fin introuvable ou invalide")
		return

	var pos_fin: Vector3 = marker.global_transform.origin
	await get_tree().process_frame

	var parent := Node3D.new()
	parent.name = "FinIndicesParent"
	racine.add_child(parent)
	parent.global_position = pos_fin

	var fin := scene_fin_indices.instantiate()
	parent.add_child(fin)
	print("[DEBUG][IndiceManager] Scene de fin indices spawnée à :", pos_fin)

	# 🔦 Gestion lumière pour mettre en valeur le TP
	var lumiere_centrale: Light3D = racine.get_node_or_null("Eclairage/LumiereCentrale")
	if lumiere_centrale:
		if lumiere_centrale is OmniLight3D:
			lumiere_centrale.light_energy *= 0.2
			print("[DEBUG][IndiceManager] Lumière OmniLight3D réduite")
		elif lumiere_centrale is SpotLight3D:
			lumiere_centrale.light_energy *= 0.2
			print("[DEBUG][IndiceManager] Lumière SpotLight3D réduite")
		elif lumiere_centrale is DirectionalLight3D:
			lumiere_centrale.light_energy *= 0.2
			print("[DEBUG][IndiceManager] Lumière DirectionalLight3D réduite")
		else:
			print("[DEBUG][IndiceManager] Type de lumière inconnu, pas de modification")
	else:
		print("[DEBUG][IndiceManager] Lumière centrale introuvable, pas de modification")
