class_name HUDDefeated
extends Control

@export var time_to_lose: float = 3.0


func _ready() -> void:
	modulate.a = 0.0


func _process(dt: float) -> void:
	dt *= Data.pause_scale
	
	if Data.disabled:
		modulate.a = minf(1.0, modulate.a + dt / time_to_lose)
		if modulate.a >= 1.0:
			SceneManager.go_to_scene(SceneManager.SCENE.DEFEAT)
