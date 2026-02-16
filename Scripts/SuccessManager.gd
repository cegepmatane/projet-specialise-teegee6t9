class_name SuccessManager
extends Node

const CHEMIN_JSON_SUCCES := "res://Data/successes.json"
const CHEMIN_SAUVEGARDE := "user://save.cfg"
const SECTION_CONFIG := "success"

static var _definitions_chargees := false
static var _ordre_definitions: Array = []
static var _definitions: Dictionary = {}
static var _debloques: Dictionary = {}

static func _assurer_definitions_chargees() -> void:
	if _definitions_chargees:
		return
	_definitions_chargees = true
	var file := FileAccess.open(CHEMIN_JSON_SUCCES, FileAccess.READ)
	if file == null:
		push_error("SuccessManager: impossible d'ouvrir %s" % CHEMIN_JSON_SUCCES)
		return
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()
	if err != OK:
		push_error("SuccessManager: JSON invalide dans %s : %s" % [CHEMIN_JSON_SUCCES, json.get_error_message()])
		return
	var data = json.get_data()
	if data is Array:
		for entry in data:
			if entry is Dictionary and entry.has("id"):
				var id_str: String = str(entry.id)
				_ordre_definitions.append(id_str)
				_definitions[id_str] = {
					"title": str(entry.get("title", "Succès")),
					"description": str(entry.get("description", ""))
				}
	else:
		push_error("SuccessManager: le JSON doit être un tableau d'objets avec id, title, description")

static func charger_depuis_disque() -> void:
	_assurer_definitions_chargees()
	var cfg := ConfigFile.new()
	var err := cfg.load(CHEMIN_SAUVEGARDE)
	_debloques.clear()
	for id in _ordre_definitions:
		if err == OK:
			_debloques[id] = bool(cfg.get_value(SECTION_CONFIG, id, false))
		else:
			_debloques[id] = false

static func sauver_sur_disque() -> void:
	var cfg := ConfigFile.new()
	for id in _ordre_definitions:
		cfg.set_value(SECTION_CONFIG, id, _debloques.get(id, false))
	cfg.save(CHEMIN_SAUVEGARDE)

static func debloquer(id_succes: String) -> bool:
	_assurer_definitions_chargees()
	if _debloques.get(id_succes, false):
		return false
	_debloques[id_succes] = true
	sauver_sur_disque()
	return true

static func est_debloque(id_succes: String) -> bool:
	_assurer_definitions_chargees()
	return _debloques.get(id_succes, false)

static func obtenir_titre_succes(id_succes: String) -> String:
	_assurer_definitions_chargees()
	var def = _definitions.get(id_succes, {})
	return def.get("title", "Succès")

static func obtenir_description_succes(id_succes: String) -> String:
	_assurer_definitions_chargees()
	var def = _definitions.get(id_succes, {})
	return def.get("description", "")

static func obtenir_tous_les_succes() -> Array:
	_assurer_definitions_chargees()
	var out: Array = []
	for id in _ordre_definitions:
		out.append({
			"id": id,
			"titre": obtenir_titre_succes(id),
			"description": obtenir_description_succes(id),
			"debloque": est_debloque(id)
		})
	return out

static func obtenir_nombre_debloques() -> int:
	_assurer_definitions_chargees()
	var n := 0
	for id in _ordre_definitions:
		if _debloques.get(id, false):
			n += 1
	return n

static func obtenir_nombre_total() -> int:
	_assurer_definitions_chargees()
	return _ordre_definitions.size()
