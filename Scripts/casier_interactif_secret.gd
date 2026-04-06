extends Node3D

@export var animation_joueur: AnimationPlayer

# Indice "classique"
@export var indice_scene: PackedScene
@export var point_spawn_indice: NodePath

# Secret (scène séparée, ex: res://Scenes/secret.tscn)
@export var secret_scene: PackedScene
@export var point_spawn_secret: NodePath

var basculer: bool = false
var interactive: bool = true
var _indice_spawn: bool = false
var _secret_spawn: bool = false
var _en_traitement: bool = false

func interact() -> void:
	if not is_instance_valid(self):
		return
	if not is_inside_tree():
		return
	if not interactive or _en_traitement:
		return

	interactive = false
	_en_traitement = true
	basculer = !basculer

	# Animation du casier / meuble
	if animation_joueur:
		if basculer:
			animation_joueur.play("Ouvrir")
		else:
			animation_joueur.play("Fermer")

	# --- Spawn de l'indice classique (comme avant) ---
	if basculer and not _indice_spawn and indice_scene:
		_indice_spawn = true

		var spawn_pos_indice: Vector3 = global_transform.origin + Vector3(0, 1.0, 0)
		if point_spawn_indice != NodePath(""):
			var point_indice = get_node_or_null(point_spawn_indice)
			if point_indice and point_indice is Node3D and point_indice.is_inside_tree():
				spawn_pos_indice = (point_indice as Node3D).global_transform.origin

		var indice := indice_scene.instantiate()
		if indice is Node3D:
			var indice_3d := indice as Node3D
			get_tree().current_scene.add_child(indice_3d)
			indice_3d.global_transform.origin = spawn_pos_indice
		else:
			push_warning("indice_scene doit avoir un Node3D comme racine")

	# --- Spawn du SECRET (secret.tscn) une seule fois ---
	if basculer and not _secret_spawn and secret_scene:
		_secret_spawn = true

		var spawn_pos_secret: Vector3 = global_transform.origin + Vector3(0, 1.0, 0)
		if point_spawn_secret != NodePath(""):
			var point_secret = get_node_or_null(point_spawn_secret)
			if point_secret and point_secret is Node3D and point_secret.is_inside_tree():
				spawn_pos_secret = (point_secret as Node3D).global_transform.origin

		var secret := secret_scene.instantiate()
		if secret is Node3D:
			var secret_3d := secret as Node3D
			get_tree().current_scene.add_child(secret_3d)
			secret_3d.global_transform.origin = spawn_pos_secret
		else:
			push_warning("secret_scene doit avoir un Node3D comme racine")

	# Cooldown
	await get_tree().create_timer(1.0).timeout
	interactive = true
	_en_traitement = false
	
	var indicateur := get_node_or_null("Indicateur3D")
	if indicateur:
		indicateur.cacher()
