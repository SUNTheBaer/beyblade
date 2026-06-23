class_name Monster
extends StaticBody2D

@export var player: PlayerMech
@export var shadow: Node2D

func _ready() -> void:
	EntityManager.subscribe(self, 480.0)


func _process(__: float) -> void:
	shadow.global_position = global_position + Data.sun_direction * 32.0
