class_name Router
extends Control

@export var battle_scene: PackedScene

var greyness_: float = 0.0: set = _set_greyness


func _set_greyness(value: float) -> void:
	greyness_ = value
	(material as ShaderMaterial).set_shader_parameter("greyness", greyness_)


func _ready() -> void:
	preload("res://Assets/KKVSTT battle theme.mp3")
	preload("res://Assets/KKVSTT main menu w intro.mp3")
	
	Data.reset()
	AudioManager.switch_music(load("res://Assets/KKVSTT main menu w intro.mp3"))
	$Poster/TextureButton.disabled = false
	$Poster/TextureButton.pressed.connect(_on_texture_button_pressed)


func _route() -> void:
	var scene := battle_scene.instantiate()
	get_tree().root.add_child(scene)
	# get_tree().current_scene = scene
	queue_free()


func _on_texture_button_pressed() -> void:
	get_tree().create_tween().tween_property(self, "greyness_", 1.0, 2.0)
	AudioManager.switch_music(null, 2.0)
	await get_tree().create_timer(3.0).timeout
	_route()
