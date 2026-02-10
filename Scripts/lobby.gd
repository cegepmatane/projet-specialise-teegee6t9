extends Node3D

@export var player_scene: PackedScene
@onready var spawn_point := $pointApparition
@onready var titre_succes_3d := $MurSucces/TitreSucces3D
@onready var succes_escape_3d := $MurSucces/SuccesEscape3D

func _ready() -> void:
	# Charger les succès depuis le disque
	SuccessManager.load_from_disk()

	var player = player_scene.instantiate()
	add_child(player)
	player.global_transform = spawn_point.global_transform

	_refresh_success_display()

func _refresh_success_display() -> void:
	var unlocked := SuccessManager.get_unlocked_count()
	var total := SuccessManager.get_total_count()

	titre_succes_3d.text = "Mes succès %d/%d" % [unlocked, total]

	if SuccessManager.has_escape_first_time():
		succes_escape_3d.text = "S'échapper pour la première fois\nSortez de la salle en franchissant la porte."
	else:
		succes_escape_3d.text = "Succès verrouillé 🔒"
