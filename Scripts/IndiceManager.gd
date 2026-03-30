extends Node

# 🔹 Gestion des indices pour UNE partie
var _indices_total: int = 10
var _indices_ramasses: Dictionary = {}
var _secret_trouve: bool = false

# 🔹 Codes générés aléatoirement
var code_couleurs: Array = []
var code_chiffres: Array = []

const COULEURS_DISPONIBLES := ["Rouge", "Vert", "Bleu", "Jaune", "Violet"]

# 🔹 Scène du panneau de code
var scene_panneau: PackedScene = null
var chemin_marker_fin: NodePath = NodePath("Structure/SalleCentrale/PointFinIndices")
var _panneau_spawn: bool = false


func reset_partie(indices_total: int = 10) -> void:
	_indices_total = indices_total
	_indices_ramasses.clear()
	_panneau_spawn = false
	_secret_trouve = false
	_generer_codes()
	print("[DEBUG][IndiceManager] reset_partie -> total =", _indices_total)
	print("[DEBUG][IndiceManager] Code couleurs :", code_couleurs)
	print("[DEBUG][IndiceManager] Code chiffres :", code_chiffres)


func _generer_codes() -> void:
	code_couleurs.clear()
	code_chiffres.clear()
	for i in range(5):
		var index: int = randi_range(0, COULEURS_DISPONIBLES.size() - 1)
		code_couleurs.append(COULEURS_DISPONIBLES[index])
	for i in range(5):
		code_chiffres.append(randi_range(0, 9))


func ramasser_indice(id_indice: String) -> void:
	if id_indice == "" or _indices_ramasses.has(id_indice):
		return
	_indices_ramasses[id_indice] = true
	print("[DEBUG][IndiceManager] Indice ramassé :", id_indice,
		" (", obtenir_nombre_trouves(), "/", _indices_total, ")")
	if not _panneau_spawn and obtenir_nombre_trouves() >= _indices_total:
		_panneau_spawn = true
		print("[DEBUG][IndiceManager] Tous les indices ramassés, spawn panneau de code")
		call_deferred("_spawn_panneau")


func obtenir_nombre_trouves() -> int:
	return _indices_ramasses.size()


func obtenir_nombre_total() -> int:
	return _indices_total


func _spawn_panneau() -> void:
	var racine := get_tree().current_scene
	if racine == null:
		return
	var panneau := racine.get_node_or_null("Structure/SalleCentrale/PanneauCode")
	if panneau:
		panneau.visible = true
		print("[DEBUG][IndiceManager] Panneau de code activé")
	else:
		push_warning("IndiceManager: PanneauCode introuvable dans la scène")
	var lumiere: Node = racine.get_node_or_null("Eclairage/LumiereCentrale")
	if lumiere and lumiere is Light3D:
		(lumiere as Light3D).light_energy *= 0.2
		print("[DEBUG][IndiceManager] Lumière réduite")
