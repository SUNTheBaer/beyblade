extends Skill

signal direction_minigame_complete

func _on_minigame_complete(result: float) -> void:
	super._on_minigame_complete(result)
	emit_signal("direction_minigame_complete", result)
	disabled = true
	await get_tree().create_timer(cooldown_timer).timeout
	disabled = false
