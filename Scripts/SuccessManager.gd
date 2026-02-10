class_name SuccessManager
extends Node

static var escape_first_time_unlocked: bool = false

static func load_from_disk() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load("user://save.cfg")
	if err == OK:
		escape_first_time_unlocked = bool(cfg.get_value("success", "escape_first_time", false))
	else:
		escape_first_time_unlocked = false

static func save_to_disk() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("success", "escape_first_time", escape_first_time_unlocked)
	cfg.save("user://save.cfg")

static func unlock_escape_first_time() -> bool:
	if escape_first_time_unlocked:
		return false
	escape_first_time_unlocked = true
	save_to_disk()
	return true

static func has_escape_first_time() -> bool:
	return escape_first_time_unlocked

static func get_unlocked_count() -> int:
	return 1 if escape_first_time_unlocked else 0

static func get_total_count() -> int:
	return 1
