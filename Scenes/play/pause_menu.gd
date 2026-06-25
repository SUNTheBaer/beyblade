class_name PauseMenu
extends Control

@export var resume_button: Button
@export var restart_button: Button
@export var main_menu_button: Button


func _ready() -> void:
	resume_button.pressed.connect(_disable)
	restart_button.pressed.connect(SceneManager.go_to_scene.bind(SceneManager.SCENE.PLAY))
	main_menu_button.pressed.connect(SceneManager.go_to_scene.bind(SceneManager.SCENE.MENU))
	_disable()


func _process(__: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if visible:
			_disable()
		else:
			_enable()


func _enable() -> void:
	get_tree().create_tween().tween_property(Data, "pause_scale", 0.0, 0.5)
	resume_button.mouse_filter = Control.MOUSE_FILTER_STOP
	restart_button.mouse_filter = Control.MOUSE_FILTER_STOP
	main_menu_button.mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true


func _disable() -> void:
	get_tree().create_tween().tween_property(Data, "pause_scale", 1.0, 0.5)
	resume_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	restart_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_menu_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
