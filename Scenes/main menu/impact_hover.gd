class_name ImpactHoverButton
extends TextureButton

@export var is_focused: bool = false: set = _set_focus


func _set_focus(value: bool) -> void:
	is_focused = value
	if is_focused:
		rotation = PI / 41.0
		scale = Vector2(1.1, 1.1)
	else:
		rotation = 0.0
		scale = Vector2.ONE


func _ready() -> void:
	pressed.connect(func() -> void:
		is_focused = false
		disabled = true)
	mouse_entered.connect(_gain_focus)
	mouse_exited.connect(_lose_focus)


func _gain_focus() -> void:
	if disabled:
		return
	is_focused = true


func _lose_focus() -> void:
	is_focused = false
