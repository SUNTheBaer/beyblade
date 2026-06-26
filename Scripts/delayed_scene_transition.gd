class_name DelayedSceneTransition
extends Node

@export var delay: float = 6.0


func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	SceneManager.go_to_scene(SceneManager.SCENE.MENU)
