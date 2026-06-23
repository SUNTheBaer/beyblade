class_name Monster
extends StaticBody2D

@export var player: PlayerMecha


func _ready() -> void:
	EntityManager.subscribe(self, 480.0)
