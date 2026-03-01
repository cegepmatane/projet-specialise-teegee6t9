extends Node

var _prochain_id: int = 1
var _indices_total: int = 10
var _indices_ramasses: Dictionary = {} # id -> true

func enregistrer_indice() -> String:
	var id := "indice_%d" % _prochain_id
	_prochain_id += 1
	return id

func ramasser_indice(id_indice: String) -> void:
	if id_indice == "":
		return
	_indices_ramasses[id_indice] = true

func obtenir_nombre_trouves() -> int:
	return _indices_ramasses.size()

func obtenir_nombre_total() -> int:
	return _indices_total
