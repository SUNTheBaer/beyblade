class_name MonsterHealthBar
extends ProgressBar

@export var monster: Monster


func _ready() -> void:
	_process(0.0)


func _process(__: float) -> void:
	global_position = monster.get_screen_transform().origin - Vector2(size.x / 2.0, 180.0)
	value = clampf(monster.hp, 0.0, 1.0)
