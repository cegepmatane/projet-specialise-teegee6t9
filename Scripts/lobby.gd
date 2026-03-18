extends Node3D

@export var scene_joueur: PackedScene
@onready var point_apparition := $pointApparition
@onready var titre_succes_3d := $MurSucces/TitreSucces3D
@onready var liste_succes := $MurSucces/ListeSucces

const TAILLE_POLICE_SUCCES := 24
const DECALAGE_Y_PAR_SUCCES := -0.55

var _popup: AcceptDialog


func _ready() -> void:
	SuccessManager.charger_depuis_disque()
	EquipmentManager.charger_depuis_disque()

	var joueur = scene_joueur.instantiate()
	add_child(joueur)
	joueur.global_transform = point_apparition.global_transform

	var hud := joueur.get_node_or_null("HUD/HUDInventaire")
	if hud:
		hud.visible = false

	var indice_label := joueur.get_node_or_null("HUD/IndiceLabel")
	if indice_label:
		indice_label.visible = false

	var timer_ui := joueur.get_node_or_null("HUD/TimerPartie")
	if timer_ui:
		timer_ui.visible = false
		timer_ui._actif = false
	
	# Créer le popup
	_popup = AcceptDialog.new()
	_popup.title = "Impossible de lancer"
	add_child(_popup)
	_popup.confirmed.connect(_sur_popup_ferme)

	_rafraichir_affichage_succes()


func afficher_erreur(message: String) -> void:
	_popup.dialog_text = message
	_popup.popup_centered()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _sur_popup_ferme() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _rafraichir_affichage_succes() -> void:
	var debloques: int = SuccessManager.obtenir_nombre_debloques()
	var total: int = SuccessManager.obtenir_nombre_total()
	titre_succes_3d.text = "Mes succès %d/%d" % [debloques, total]
	for child in liste_succes.get_children():
		child.queue_free()
	var index := 0
	for s in SuccessManager.obtenir_tous_les_succes():
		var label := Label3D.new()
		label.font_size = TAILLE_POLICE_SUCCES
		if s.debloque:
			label.text = "%s\n%s" % [s.titre, s.description]
		else:
			label.text = "Succès verrouillé 🔒"
		label.position = Vector3(0, index * DECALAGE_Y_PAR_SUCCES, 0)
		liste_succes.add_child(label)
		index += 1


func ouvrir_boutique() -> void:
	$BoutiqueUI.ouvrir()


func fermer_boutique() -> void:
	$BoutiqueUI.fermer()
