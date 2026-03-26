extends Node

const CHEMIN_JSON_SUCCES := "res://Data/successes.json"
const CHEMIN_SAUVEGARDE := "user://save.cfg"

const SECTION_CONFIG := "success"
const SECTION_STATS := "stats"

var _definitions_chargees := false
var _ordre_definitions: Array = []
var _definitions: Dictionary = {}
var _conditions: Dictionary = {}

var _debloques: Dictionary = {}

var _parties_reussies: int = 0


func _assurer_definitions_chargees() -> void:

	if _definitions_chargees:
		return

	_definitions_chargees = true

	var file := FileAccess.open(CHEMIN_JSON_SUCCES, FileAccess.READ)

	if file == null:
		push_error("Impossible d'ouvrir successes.json")
		return

	var json := JSON.new()
	var err := json.parse(file.get_as_text())

	file.close()

	if err != OK:
		push_error("JSON invalide")
		return

	var data = json.get_data()

	if data is Array:

		for entry in data:

			if entry is Dictionary and entry.has("id"):

				var id_str := str(entry.id)

				_ordre_definitions.append(id_str)

				_definitions[id_str] = {
					"title": str(entry.get("title", "Succès")),
					"description": str(entry.get("description", ""))
				}

				if entry.has("condition"):
					_conditions[id_str] = entry["condition"]


func charger_depuis_disque() -> void:

	_assurer_definitions_chargees()

	var cfg := ConfigFile.new()
	var err := cfg.load(CHEMIN_SAUVEGARDE)

	_debloques.clear()

	if err == OK:

		for id in _ordre_definitions:
			_debloques[id] = bool(cfg.get_value(SECTION_CONFIG, id, false))

		_parties_reussies = int(cfg.get_value(SECTION_STATS, "parties_reussies", 0))

	else:

		for id in _ordre_definitions:
			_debloques[id] = false

		_parties_reussies = 0


func sauver_sur_disque() -> void:

	var cfg := ConfigFile.new()
	cfg.load(CHEMIN_SAUVEGARDE)
	for id in _ordre_definitions:
		cfg.set_value(SECTION_CONFIG, id, _debloques.get(id, false))

	cfg.set_value(SECTION_STATS, "parties_reussies", _parties_reussies)

	cfg.save(CHEMIN_SAUVEGARDE)


func debloquer(id_succes: String) -> bool:

	if _debloques.get(id_succes, false):
		return false

	_debloques[id_succes] = true

	print("[SUCCESS] Succès débloqué :", id_succes)

	return true


func est_debloque(id_succes: String) -> bool:
	return _debloques.get(id_succes, false)


func obtenir_titre_succes(id_succes: String) -> String:
	var def = _definitions.get(id_succes, {})
	return def.get("title", "Succès")


func obtenir_description_succes(id_succes: String) -> String:
	var def = _definitions.get(id_succes, {})
	return def.get("description", "")


func verifier_succes_parties() -> Array:
	var nouveaux: Array = []
	var ids = _conditions.keys().duplicate()
	for id in ids:
		if est_debloque(id):
			continue
		var condition = _conditions[id]
		if condition.has("type") and condition["type"] == "parties_reussies":
			var seuil = int(condition.get("value", 0))
			if _parties_reussies >= seuil:
				if debloquer(id):
					nouveaux.append(id)
	return nouveaux


func incrementer_et_verifier() -> Array:
	_parties_reussies += 1
	print("[DEBUG] Parties réussies :", _parties_reussies)
	var nouveaux := verifier_succes_parties()
	sauver_sur_disque()
	return nouveaux


func obtenir_parties_reussies() -> int:
	return _parties_reussies


func obtenir_nombre_debloques() -> int:
	var n: int = 0

	for id in _ordre_definitions:
		if _debloques.get(id, false):
			n += 1

	return n


func obtenir_nombre_total() -> int:
	return _ordre_definitions.size()


func obtenir_tous_les_succes() -> Array:

	var out: Array = []

	for id in _ordre_definitions:

		out.append({
			"id": id,
			"titre": obtenir_titre_succes(id),
			"description": obtenir_description_succes(id),
			"debloque": est_debloque(id)
		})

	return out
	
func verifier_succes_temps_ecoule(temps_ecoule: float) -> Array:
	var nouveaux: Array = []
	var ids = _conditions.keys().duplicate()
	for id in ids:
		if est_debloque(id):
			continue
		var condition = _conditions[id]
		if condition.has("type") and condition["type"] == "temps_ecoule_secondes":
			var seuil: float = float(condition.get("value", 120))
			if temps_ecoule <= seuil:
				if debloquer(id):
					nouveaux.append(id)
	sauver_sur_disque()
	return nouveaux
