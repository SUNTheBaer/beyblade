extends Camera2D

@onready var monster: Monster = $"../../../../../../Monster"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = monster.position
