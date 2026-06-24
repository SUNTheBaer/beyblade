class_name Router
extends Node

@export var battle_scene: PackedScene
@export var minigame_scene: PackedScene


func _route() -> void:
	if OS.has_feature("debug_minigame"):
		get_tree().change_scene_to_packed(minigame_scene)
	
	get_tree().change_scene_to_packed(battle_scene)


func _on_texture_button_pressed() -> void:
	_route()
