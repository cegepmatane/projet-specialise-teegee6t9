class_name SuccessManager
extends Node

static var escape_first_time_unlocked: bool = false

static func unlock_escape_first_time() -> void:
	escape_first_time_unlocked = true

static func has_escape_first_time() -> bool:
	return escape_first_time_unlocked

static func get_unlocked_count() -> int:
	return 1 if escape_first_time_unlocked else 0

static func get_total_count() -> int:
	return 1
