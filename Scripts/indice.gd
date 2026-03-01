extends Node3D

@export var description: String = ""

var _ramasse: bool = false
var _id_indice: String = ""

func _ready() -> void:
	# Demande un ID unique automatiquement au manager
	_id_indice = IndiceManager.enregistrer_indice()

func interact() -> void:
	if _ramasse:
		return

	_ramasse = true

	if _id_indice != "":
		IndiceManager.ramasser_indice(_id_indice)

	# ici tu peux jouer un son / anim si tu veux

	queue_free()
