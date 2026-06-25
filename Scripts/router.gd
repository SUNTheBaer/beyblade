class_name Router
extends Control

@export var battle_scene: PackedScene
@export var minigame_scene: PackedScene

var greyness_: float = 0.0: set = _set_greyness


func _set_greyness(value: float) -> void:
	greyness_ = value
	(material as ShaderMaterial).set_shader_parameter("greyness", greyness_)


func _ready() -> void:
	AudioManager.switch_music(load("res://Assets/KKVSTT main menu w intro.mp3"))
	$Poster/TextureButton.disabled = false
	$Poster/TextureButton.pressed.connect(_on_texture_button_pressed)


func _route() -> void:
	AudioManager.switch_music(load("res://Assets/KKVSTT battle theme.mp3"), 12.0)
	
	var scene := battle_scene.instantiate()
	get_tree().current_scene = scene
	get_tree().root.add_child(scene)
	queue_free()


func _on_texture_button_pressed() -> void:
	get_tree().create_tween().tween_property(self, "greyness_", 1.0, 2.0)
	AudioManager.switch_music(null, 2.0)
	await get_tree().create_timer(3.0).timeout
	_route()
