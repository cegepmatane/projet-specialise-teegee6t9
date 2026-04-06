extends Label3D

@export var texte: String = "E — Interagir"
@export var hauteur: float = 1.5
@export var vitesse_bob: float = 1.5
@export var amplitude_bob: float = 0.1

var _temps: float = 0.0
var _position_base: Vector3


func _ready() -> void:
	text = texte
	_position_base = position
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	font_size = 48
	modulate = Color(1, 1, 0.2)  # Jaune
	
	var cfg := ConfigFile.new()
	if cfg.load("user://save.cfg") == OK:
		var parties: int = cfg.get_value("stats", "parties_reussies", 0)
		visible = parties == 0
	else:
		visible = true


func _process(delta: float) -> void:
	_temps += delta
	position.y = _position_base.y + sin(_temps * vitesse_bob) * amplitude_bob


func cacher() -> void:
	visible = false
