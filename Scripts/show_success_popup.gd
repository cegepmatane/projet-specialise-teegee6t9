extends Node3D

@onready var black_screen := $CanvasLayer/EcranNoir
@onready var notification_panel := $CanvasLayer/NotificationPanel
@onready var notification_label := $CanvasLayer/NotificationPanel/Text

var _is_showing := false

func _ready() -> void:
	print("show_success_popup.gd READY")
	print("  black_screen:", black_screen)
	print("  notification_panel:", notification_panel)
	print("  notification_label:", notification_label)
	black_screen.visible = false
	notification_panel.visible = false


func show_success_with_transition(text: String, duration: float = 2.0) -> void:
	if _is_showing:
		return
	_is_showing = true

	notification_label.text = text
	print("  label final text:", notification_label.text)

	black_screen.visible = true
	notification_panel.visible = true

	var rect: Rect2 = notification_panel.get_rect()
	var start_pos: Vector2 = Vector2(0, -rect.size.y)
	var target_pos: Vector2 = Vector2(0, 0)

	notification_panel.position = start_pos

	var tween := create_tween()
	tween.tween_property(notification_panel, "position", target_pos, 0.4)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	await tween.finished
	await get_tree().create_timer(duration).timeout

	var tween_up := create_tween()
	tween_up.tween_property(notification_panel, "position", start_pos, 0.4)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween_up.finished

	notification_panel.visible = false
	black_screen.visible = false
	_is_showing = false
