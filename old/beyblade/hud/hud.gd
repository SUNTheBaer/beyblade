class_name HUDold
extends Control

@export var player: PlayerMecha


func _ready() -> void:
	player.tree_exiting.connect(queue_free)
