extends Node3D

## Écran blanc = écran de chargement uniquement (ex: pendant un changement de scène).
## Les succès n'affichent que la popup, sauf si on demande explicitement l'écran de chargement (ex: succès "sortie" pendant le chargement).

@onready var loading_screen := $CanvasLayer/EcranBlanc
@onready var notification_panel := $CanvasLayer/NotificationPanel
@onready var notification_label := $CanvasLayer/NotificationPanel/Text

var _is_showing := false

func _ready() -> void:
	loading_screen.visible = false
	notification_panel.visible = false

## Affiche la popup de succès. Si use_loading_screen est true, l'écran blanc (chargement) est affiché derrière
## et reste visible après la popup (pour un changement de scène juste après).
func show_success_with_transition(text: String, duration: float = 2.0, use_loading_screen: bool = false) -> void:
	if _is_showing:
		return
	_is_showing = true

	notification_label.text = text
	loading_screen.visible = use_loading_screen
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
	if not use_loading_screen:
		loading_screen.visible = false
	_is_showing = false
