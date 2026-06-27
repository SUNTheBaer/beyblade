class_name Skill
extends Button

signal ability_clicked

@onready var minigame_display: Control = %MinigameDisplay

@export var all_skills: Array[Skill]
@export var minigame_scene: PackedScene
@export var cooldown_timer = 7.0


func _ready():
	pressed.connect(_on_skill_pressed)
	($MarginContainer/ProgressBar as ProgressBar).value = 0.0


func _on_skill_pressed() -> void:
	if minigame_display.get_child_count() != 0:
		return
	
	ability_clicked.emit()
	var instance = minigame_scene.instantiate() as Minigame
	instance.minigame_complete.connect(_on_minigame_complete)
	minigame_display.add_child(instance)
	minigame_display.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_minigame_complete(__: float) -> void:
	minigame_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	($MarginContainer/ProgressBar as ProgressBar).value = 1.0
	get_tree().create_tween().tween_property($MarginContainer/ProgressBar, "value", 0.0, cooldown_timer)
