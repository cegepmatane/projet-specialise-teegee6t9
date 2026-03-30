extends StaticBody3D

@export var delta: int = 1

@onready var label: Label3D = $Label3D


func _ready() -> void:
	# S'abonner au changement de page
	get_tree().current_scene.connect("page_changee", _mettre_a_jour_visibilite)
	_mettre_a_jour_visibilite()


func interact() -> void:
	get_tree().current_scene.changer_page(delta)


func _mettre_a_jour_visibilite() -> void:
	var lobby := get_tree().current_scene
	var tous := SuccessManager.obtenir_tous_les_succes()
	var nb_pages: int = ceili(float(tous.size()) / float(5))
	var page: int = lobby._page_actuelle

	if delta == -1:
		visible = page > 0
	elif delta == 1:
		visible = page < nb_pages - 1
