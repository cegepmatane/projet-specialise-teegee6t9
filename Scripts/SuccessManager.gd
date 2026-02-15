class_name SuccessManager
extends Node

## Charge les succès depuis Data/successes.json. Ajoute une entrée dans ce fichier
## pour chaque nouveau succès ; l'ordre du JSON = ordre d'affichage sur le mur.

const SUCCESSES_JSON_PATH := "res://Data/successes.json"
const SAVE_PATH := "user://save.cfg"
const CONFIG_SECTION := "success"

static var _definitions_loaded := false
static var _definition_order: Array = []  # [id, id, ...] pour garder l'ordre du JSON
static var _definitions: Dictionary = {}  # id (String) -> { "title", "description" }
static var _unlocked: Dictionary = {}     # id (String) -> bool

static func _ensure_definitions_loaded() -> void:
	if _definitions_loaded:
		return
	_definitions_loaded = true
	var file := FileAccess.open(SUCCESSES_JSON_PATH, FileAccess.READ)
	if file == null:
		push_error("SuccessManager: impossible d'ouvrir %s" % SUCCESSES_JSON_PATH)
		return
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()
	if err != OK:
		push_error("SuccessManager: JSON invalide dans %s : %s" % [SUCCESSES_JSON_PATH, json.get_error_message()])
		return
	var data = json.get_data()
	if data is Array:
		for entry in data:
			if entry is Dictionary and entry.has("id"):
				var id_str: String = str(entry.id)
				_definition_order.append(id_str)
				_definitions[id_str] = {
					"title": str(entry.get("title", "Succès")),
					"description": str(entry.get("description", ""))
				}
	else:
		push_error("SuccessManager: le JSON doit être un tableau d'objets avec id, title, description")

static func load_from_disk() -> void:
	_ensure_definitions_loaded()
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	_unlocked.clear()
	for id in _definition_order:
		if err == OK:
			_unlocked[id] = bool(cfg.get_value(CONFIG_SECTION, id, false))
		else:
			_unlocked[id] = false

static func save_to_disk() -> void:
	var cfg := ConfigFile.new()
	for id in _definition_order:
		cfg.set_value(CONFIG_SECTION, id, _unlocked.get(id, false))
	cfg.save(SAVE_PATH)

## Débloque un succès par son ID (string, ex: "escape_first_time"). Retourne true si c'était encore verrouillé.
static func unlock(success_id: String) -> bool:
	_ensure_definitions_loaded()
	if _unlocked.get(success_id, false):
		return false
	_unlocked[success_id] = true
	save_to_disk()
	return true

## Indique si un succès est débloqué.
static func is_unlocked(success_id: String) -> bool:
	_ensure_definitions_loaded()
	return _unlocked.get(success_id, false)

## Titre d'un succès (pour popup et affichage).
static func get_success_title(success_id: String) -> String:
	_ensure_definitions_loaded()
	var def = _definitions.get(success_id, {})
	return def.get("title", "Succès")

## Description d'un succès.
static func get_success_description(success_id: String) -> String:
	_ensure_definitions_loaded()
	var def = _definitions.get(success_id, {})
	return def.get("description", "")

## Liste de toutes les définitions avec état débloqué, dans l'ordre du fichier JSON.
## Chaque élément : { "id": String, "title": String, "description": String, "unlocked": bool }
static func get_all_successes() -> Array:
	_ensure_definitions_loaded()
	var out: Array = []
	for id in _definition_order:
		out.append({
			"id": id,
			"title": get_success_title(id),
			"description": get_success_description(id),
			"unlocked": is_unlocked(id)
		})
	return out

static func get_unlocked_count() -> int:
	_ensure_definitions_loaded()
	var n := 0
	for id in _definition_order:
		if _unlocked.get(id, false):
			n += 1
	return n

static func get_total_count() -> int:
	_ensure_definitions_loaded()
	return _definition_order.size()
