extends StaticBody3D

const COULEURS := {
	"Rouge":  Color(1, 0, 0),
	"Vert":   Color(0, 1, 0),
	"Bleu":   Color(0, 0.4, 1),
	"Jaune":  Color(1, 1, 0),
	"Violet": Color(0.6, 0, 1)
}

var _entree_couleurs: Array = ["", "", "", "", ""]
var _entree_chiffres: Array = [-1, -1, -1, -1, -1]
var _slot_couleur_actif: int = 0
var _slot_chiffre_actif: int = 0
var _ouvert: bool = false


func interact() -> void:
	if not _ouvert:
		_ouvrir_panneau()


func _ouvrir_panneau() -> void:
	_ouvert = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().current_scene.ouvrir_panneau_code(self)


func soumettre_couleur(couleur: String) -> void:
	if _slot_couleur_actif >= 5:
		return
	_entree_couleurs[_slot_couleur_actif] = couleur
	_slot_couleur_actif += 1
	print("[PANNEAU] Couleurs :", _entree_couleurs)
	_verifier_codes()


func soumettre_chiffre(chiffre: int) -> void:
	if _slot_chiffre_actif >= 5:
		return
	_entree_chiffres[_slot_chiffre_actif] = chiffre
	_slot_chiffre_actif += 1
	print("[PANNEAU] Chiffres :", _entree_chiffres)
	_verifier_codes()


func effacer_couleurs() -> void:
	_entree_couleurs = ["", "", "", "", ""]
	_slot_couleur_actif = 0


func effacer_chiffres() -> void:
	_entree_chiffres = [-1, -1, -1, -1, -1]
	_slot_chiffre_actif = 0


func obtenir_couleurs() -> Dictionary:
	return COULEURS


func _verifier_codes() -> void:
	if _slot_couleur_actif < 5 or _slot_chiffre_actif < 5:
		return

	var couleurs_ok := _entree_couleurs == IndiceManager.code_couleurs
	var chiffres_ok := true
	for i in range(5):
		if _entree_chiffres[i] != IndiceManager.code_chiffres[i]:
			chiffres_ok = false
			break

	if couleurs_ok and chiffres_ok:
		print("[PANNEAU] Codes corrects ! Spawn téléporteur")
		get_tree().current_scene.fermer_panneau_code()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_ouvert = false
		_spawn_teleporteur()
	else:
		print("[PANNEAU] Codes incorrects")
		get_tree().current_scene.afficher_erreur_code(couleurs_ok, chiffres_ok)
		effacer_couleurs()
		effacer_chiffres()


func _spawn_teleporteur() -> void:
	var racine := get_tree().current_scene
	var marker := racine.get_node_or_null(IndiceManager.chemin_marker_fin)
	if marker == null or not marker is Node3D:
		push_warning("Marker de fin introuvable")
		return
	var fin: Node3D = load("res://Scenes/fin_indices.tscn").instantiate()
	racine.add_child(fin)
	fin.global_position = (marker as Node3D).global_position
	print("[PANNEAU] Téléporteur spawné à :", fin.global_position)
