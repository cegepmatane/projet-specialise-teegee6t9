extends Node

const CHEMIN_JSON_EQUIPMENT := "res://Data/equipment.json"
const CHEMIN_SAUVEGARDE := "user://save.cfg"

const SECTION_EQUIPMENT := "equipment"
const SECTION_PRESETS := "presets"
const SECTION_ACTIVE_PRESET := "active_preset"
const SECTION_ARGENT := "argent"

const GAIN_PARTIE := 25
const BONUS_SECRET := 5
const ITEM_GRATUIT := "lampe"
const NB_SLOTS := 3

# Définitions chargées depuis le JSON
var _definitions: Dictionary = {}
var _ordre_definitions: Array = []

# État du joueur
var _argent: int = 0
var _inventaire: Dictionary = {}        # id -> quantité
var _presets: Dictionary = {            # nom -> Array[id|""]
	"preset_1": ["", "", ""],
	"preset_2": ["", "", ""]
}
var _active_preset: String = ""
var _slots_actifs: Array = ["", "", ""] # slot 0/1/2 -> id équipé


func _ready() -> void:
	_charger_definitions()
	charger_depuis_disque()


# ─────────────────────────────────────────
#  CHARGEMENT DES DÉFINITIONS JSON
# ─────────────────────────────────────────

func _charger_definitions() -> void:
	var file := FileAccess.open(CHEMIN_JSON_EQUIPMENT, FileAccess.READ)
	if file == null:
		push_error("Impossible d'ouvrir equipment.json")
		return

	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()

	if err != OK:
		push_error("equipment.json invalide")
		return

	var data = json.get_data()
	if data is Array:
		for entry in data:
			if entry is Dictionary and entry.has("id"):
				var id_str := str(entry["id"])
				_ordre_definitions.append(id_str)
				_definitions[id_str] = {
					"nom":       str(entry.get("nom", id_str)),
					"prix":      int(entry.get("prix", 0)),
					"stack_max": int(entry.get("stack_max", 1)),
					"gratuit":   bool(entry.get("gratuit", false))
				}


# ─────────────────────────────────────────
#  PERSISTANCE
# ─────────────────────────────────────────

func charger_depuis_disque() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(CHEMIN_SAUVEGARDE)

	if err == OK:
		_argent = int(cfg.get_value(SECTION_ARGENT, "total", 0))

		_inventaire.clear()
		for id in _ordre_definitions:
			var qte := int(cfg.get_value(SECTION_EQUIPMENT, id, 0))
			if qte > 0:
				_inventaire[id] = qte

		for nom in _presets.keys():
			var sauvegarde = cfg.get_value(SECTION_PRESETS, nom, ["", "", ""])
			if sauvegarde is Array:
				_presets[nom] = sauvegarde
			else:
				_presets[nom] = ["", "", ""]

		_active_preset = str(cfg.get_value(SECTION_ACTIVE_PRESET, "nom", ""))

	else:
		# Première fois : donner la lampe gratuitement
		_argent = 0
		_inventaire.clear()
		_inventaire[ITEM_GRATUIT] = 1
		_presets = { "preset_1": ["", "", ""], "preset_2": ["", "", ""] }
		_active_preset = ""
		sauver_sur_disque()


func sauver_sur_disque() -> void:
	var cfg := ConfigFile.new()
	cfg.load(CHEMIN_SAUVEGARDE)
	cfg.set_value(SECTION_ARGENT, "total", _argent)
	for id in _ordre_definitions:
		cfg.set_value(SECTION_EQUIPMENT, id, _inventaire.get(id, 0))
	for nom in _presets.keys():
		cfg.set_value(SECTION_PRESETS, nom, _presets[nom])
	cfg.set_value(SECTION_ACTIVE_PRESET, "nom", _active_preset)
	var err := cfg.save(CHEMIN_SAUVEGARDE)
	print("[EQUIPMENT] sauver_sur_disque err=", err, " argent=", _argent)


# ─────────────────────────────────────────
#  ARGENT
# ─────────────────────────────────────────

func obtenir_argent() -> int:
	return _argent


func ajouter_argent(montant: int) -> void:
	_argent += montant
	print("[EQUIPMENT] Argent ajouté : +", montant, " → total =", _argent)
	sauver_sur_disque()


func gagner_argent_partie() -> void:
	print("[EQUIPMENT] gagner_argent_partie appelé, avant =", _argent)
	ajouter_argent(GAIN_PARTIE)
	print("[EQUIPMENT] après =", _argent)


func gagner_bonus_secret() -> void:
	ajouter_argent(BONUS_SECRET)


# ─────────────────────────────────────────
#  BOUTIQUE
# ─────────────────────────────────────────

func acheter(id: String) -> bool:
	if not _definitions.has(id):
		push_error("Item inconnu : " + id)
		return false

	var def: Dictionary = _definitions[id]
	var prix: int = def["prix"]
	var stack_max: int = def["stack_max"]
	var qte_actuelle: int = _inventaire.get(id, 0)

	if qte_actuelle >= stack_max:
		print("[EQUIPMENT] Stack max atteint pour : ", id)
		return false

	if _argent < prix:
		print("[EQUIPMENT] Pas assez d'argent pour : ", id)
		return false

	_argent -= prix
	_inventaire[id] = qte_actuelle + 1
	print("[EQUIPMENT] Acheté : ", id, " (", _inventaire[id], "/", stack_max, ")")
	sauver_sur_disque()
	return true


func obtenir_quantite(id: String) -> int:
	return _inventaire.get(id, 0)

func obtenir_prix(id: String) -> int:
	var def: Dictionary = _definitions.get(id, {})
	return def.get("prix", 0)

func peut_acheter(id: String) -> bool:
	if not _definitions.has(id):
		return false
	var def: Dictionary = _definitions[id]
	return _argent >= def["prix"] and _inventaire.get(id, 0) < def["stack_max"]


func obtenir_tous_les_items() -> Array:
	var out: Array = []
	for id in _ordre_definitions:
		var def: Dictionary = _definitions[id]
		out.append({
			"id":         id,
			"nom":        def["nom"],
			"prix":       def["prix"],
			"stack_max":  def["stack_max"],
			"quantite":   _inventaire.get(id, 0),
			"peut_acheter": peut_acheter(id)
		})
	return out

func desactiver_preset() -> void:
	_active_preset = ""
	_slots_actifs = ["", "", ""]
	print("[EQUIPMENT] Preset désactivé")
	sauver_sur_disque()

# ─────────────────────────────────────────
#  CONSOMMATION EN PARTIE
# ─────────────────────────────────────────

func consommer(id: String, n: int = 1) -> bool:
	var qte: int = _inventaire.get(id, 0)
	if qte < n:
		return false
	_inventaire[id] = qte - n
	if _inventaire[id] <= 0:
		_inventaire.erase(id)
	sauver_sur_disque()
	return true


func reset_on_failure() -> void:
	# Perd l'équipement des slots actifs
	for id in _slots_actifs:
		if id != "":
			consommer(id)
	_slots_actifs = ["", "", ""]
	print("[EQUIPMENT] Équipement perdu suite à l'échec")
	sauver_sur_disque()


# ─────────────────────────────────────────
#  SLOTS ACTIFS (1/2/3 en jeu)
# ─────────────────────────────────────────

func equiper_slot(slot: int, id: String) -> void:
	if slot < 0 or slot >= NB_SLOTS:
		return
	_slots_actifs[slot] = id


func obtenir_slot(slot: int) -> String:
	if slot < 0 or slot >= NB_SLOTS:
		return ""
	return _slots_actifs[slot]


func obtenir_slots_actifs() -> Array:
	return _slots_actifs.duplicate()


# ─────────────────────────────────────────
#  PRÉSETS
# ─────────────────────────────────────────

func enregistrer_preset(nom: String, slots: Array) -> void:
	if not _presets.has(nom):
		push_error("Preset inconnu : " + nom)
		return
	_presets[nom] = slots.duplicate()
	print("[EQUIPMENT] Preset enregistré : ", nom, " -> ", slots)
	sauver_sur_disque()


func appliquer_preset(nom: String) -> bool:
	if not _presets.has(nom):
		return false
	_slots_actifs = _presets[nom].duplicate()
	_active_preset = nom
	print("[EQUIPMENT] Preset appliqué : ", nom)
	sauver_sur_disque()
	return true


func obtenir_preset(nom: String) -> Array:
	return _presets.get(nom, ["", "", ""])


func obtenir_active_preset() -> String:
	return _active_preset
