extends Node3D

@export var player_scene: PackedScene
@onready var spawn_point := $pointApparition
@onready var titre_succes_3d := $MurSucces/TitreSucces3D
@onready var liste_succes := $MurSucces/ListeSucces

const FONT_SIZE_SUCCES := 24
const OFFSET_Y_PAR_SUCCES := -0.55

func _ready() -> void:
	SuccessManager.load_from_disk()

	var player = player_scene.instantiate()
	add_child(player)
	player.global_transform = spawn_point.global_transform

	_refresh_success_display()

func _refresh_success_display() -> void:
	var unlocked := SuccessManager.get_unlocked_count()
	var total := SuccessManager.get_total_count()
	titre_succes_3d.text = "Mes succès %d/%d" % [unlocked, total]

	# Nettoyer les anciens labels
	for child in liste_succes.get_children():
		child.queue_free()

	# Créer un Label3D par succès (ordre du registre)
	var index := 0
	for s in SuccessManager.get_all_successes():
		var label := Label3D.new()
		label.font_size = FONT_SIZE_SUCCES
		if s.unlocked:
			label.text = "%s\n%s" % [s.title, s.description]
		else:
			label.text = "Succès verrouillé 🔒"
		label.position = Vector3(0, index * OFFSET_Y_PAR_SUCCES, 0)
		liste_succes.add_child(label)
		index += 1
