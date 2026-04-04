extends Node3D

@onready var ecran_chargement := $CanvasLayer/EcranBlanc
@onready var panneau_notification := $CanvasLayer/CanvasLayer/PanneauNotification
@onready var label_notification := $CanvasLayer/CanvasLayer/PanneauNotification/Texte
@onready var panneau_code_ui := $CanvasLayer/PanneauCodeUI

@export var nombre_indices: int = 10

var _en_affichage := false


func _ready() -> void:
	ecran_chargement.visible = false
	panneau_notification.visible = false
	IndiceManager.reset_partie(nombre_indices)
	
	var eclairage := get_node_or_null("Eclairage")
	if eclairage:
		for lumiere in eclairage.get_children():
			if lumiere is Light3D:
				lumiere.light_energy *= 0.05


func afficher_succes_avec_transition(
	texte: String,
	duree: float = 2.0,
	utiliser_ecran_chargement: bool = false
) -> void:
	if _en_affichage:
		return
	_en_affichage = true
	label_notification.text = texte
	ecran_chargement.visible = utiliser_ecran_chargement
	panneau_notification.visible = true
	var rect: Rect2 = panneau_notification.get_rect()
	var pos_depart: Vector2 = Vector2(0, -rect.size.y)
	var pos_cible: Vector2 = Vector2(0, 0)
	panneau_notification.position = pos_depart
	var tween := create_tween()
	tween.tween_property(panneau_notification, "position", pos_cible, 0.4)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	await get_tree().create_timer(duree).timeout
	var tween_haut := create_tween()
	tween_haut.tween_property(panneau_notification, "position", pos_depart, 0.4)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween_haut.finished
	panneau_notification.visible = false
	if not utiliser_ecran_chargement:
		ecran_chargement.visible = false
	_en_affichage = false


func afficher_indice(type: String, num_position: int, valeur: String) -> void:
	var texte: String = ""
	if type == "couleur":
		texte = "Couleur %d : %s" % [num_position, valeur]
	else:
		texte = "Chiffre %d : %s" % [num_position, valeur]
	afficher_succes_avec_transition(texte, 2.0, false)


func ouvrir_panneau_code(panneau: Node) -> void:
	panneau_code_ui.ouvrir(panneau)


func fermer_panneau_code() -> void:
	panneau_code_ui.fermer()


func afficher_erreur_code(couleurs_ok: bool, chiffres_ok: bool) -> void:
	panneau_code_ui.afficher_erreur(couleurs_ok, chiffres_ok)
