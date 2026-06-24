class_name Skill
extends Button

signal ability_clicked

@onready var minigame_display: Control = %MinigameDisplay

@export var all_skills: Array[Skill]
@export var minigame_scene: PackedScene
@export var cooldown_timer = 7.0

func _ready():
	self.connect("pressed", _on_skill_pressed)

func _on_skill_pressed() -> void:
	emit_signal("ability_clicked")
	for skill in all_skills:
		skill.disabled = true
	var instance = minigame_scene.instantiate()
	instance.connect("minigame_complete", _on_minigame_complete)
	minigame_display.add_child(instance)

func _on_minigame_complete(result: float) -> void:
	for skill in all_skills:
		skill.disabled = false
