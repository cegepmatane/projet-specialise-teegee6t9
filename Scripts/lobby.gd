extends Node3D

@export var scene_joueur: PackedScene
@onready var point_apparition := $pointApparition
@onready var titre_succes_3d := $MurSucces/TitreSucces3D
@onready var liste_succes := $MurSucces/ListeSucces

const TAILLE_POLICE_SUCCES := 24
const DECALAGE_Y_PAR_SUCCES := -0.55

func _ready() -> void:
	SuccessManager.charger_depuis_disque()

	var joueur = scene_joueur.instantiate()
	add_child(joueur)
	joueur.global_transform = point_apparition.global_transform
	
	var indice_label := joueur.get_node_or_null("HUD/IndiceLabel")
	if indice_label:
		indice_label.visible = false

	_rafraichir_affichage_succes()

func _rafraichir_affichage_succes() -> void:
	var debloques := SuccessManager.obtenir_nombre_debloques()
	var total := SuccessManager.obtenir_nombre_total()
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
