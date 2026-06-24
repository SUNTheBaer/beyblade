class_name HUDExplosion
extends Control

var accum_: float = 0.0


func _process(dt: float) -> void:
	if not Data.victory:
		return
	accum_ = minf(3000.0, accum_ + (accum_ + 128.0) * dt / maxf(0.01, Engine.time_scale))
	if accum_ >= 3000.0:
		SceneManager.go_to_scene(SceneManager.SCENE.VICTORY)
		return
	queue_redraw()


func _draw() -> void:
	draw_circle(get_viewport_rect().size / 2.0, accum_, Color.WHITE)
