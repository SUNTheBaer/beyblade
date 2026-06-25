class_name HUDOutOfBoundsAlert
extends HUDComponent

@export var player: PlayerMech


func _process(__: float) -> void:
	is_capacity_exceeded = player.is_out_of_bounds()
