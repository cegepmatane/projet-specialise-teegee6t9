extends Node3D

@export var scene_joueur: PackedScene
@onready var point_apparition := $pointApparition
@onready var titre_succes_3d := $MurSucces/TitreSucces3D
@onready var liste_succes := $MurSucces/ListeSucces

const TAILLE_POLICE_SUCCES := 18
const DECALAGE_Y_PAR_SUCCES := -0.45
const SUCCES_PAR_PAGE := 5

var _page_actuelle: int = 0
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

	var carnet := joueur.get_node_or_null("HUD/CarnetIndices")
	if carnet:
		carnet.visible = false
		carnet.set_process_unhandled_input(false)
		
	var menu_pause := joueur.get_node_or_null("HUD/MenuPause")
	if menu_pause:
		menu_pause.set_process_mode(Node.PROCESS_MODE_DISABLED)

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
	var tous := SuccessManager.obtenir_tous_les_succes()
	var debloques: int = SuccessManager.obtenir_nombre_debloques()
	var total: int = SuccessManager.obtenir_nombre_total()
	var nb_pages: int = ceili(float(total) / float(SUCCES_PAR_PAGE))

	titre_succes_3d.text = "Mes succès %d/%d  (page %d/%d)" % [debloques, total, _page_actuelle + 1, nb_pages]

	for child in liste_succes.get_children():
		child.queue_free()

	# Afficher seulement les succès de la page actuelle
	var debut: int = _page_actuelle * SUCCES_PAR_PAGE
	var fin: int = mini(debut + SUCCES_PAR_PAGE, total)

	var index := 0
	for i in range(debut, fin):
		var s = tous[i]
		var label := Label3D.new()
		label.font_size = TAILLE_POLICE_SUCCES
		if s.debloque:
			label.text = "✓ %s\n  %s" % [s.titre, s.description]
			label.modulate = Color(0.2, 1, 0.4)
		else:
			label.text = "🔒 Succès verrouillé"
			label.modulate = Color(0.6, 0.6, 0.6)
		label.position = Vector3(0, index * DECALAGE_Y_PAR_SUCCES, 0)
		liste_succes.add_child(label)
		index += 1
		page_changee.emit()


signal page_changee

func changer_page(delta: int) -> void:
	var tous := SuccessManager.obtenir_tous_les_succes()
	var nb_pages: int = ceili(float(tous.size()) / float(SUCCES_PAR_PAGE))
	_page_actuelle = clamp(_page_actuelle + delta, 0, nb_pages - 1)
	_rafraichir_affichage_succes()
	page_changee.emit()


func ouvrir_boutique() -> void:
	$BoutiqueUI.ouvrir()


func fermer_boutique() -> void:
	$BoutiqueUI.fermer()
