class_name HUDTimeScaleMonitor
extends HUDComponent

@export var threshold := 1.0


func _process(__: float) -> void:
	is_capacity_exceeded = Data.impact_sensor < threshold
