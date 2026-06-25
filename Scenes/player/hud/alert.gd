class_name HUDAlert
extends Control

@export var display_text: String: set = _set_display_text
@export var alert_cadence: float = 8.0
@export var destroy: bool = false

@export_group("Internal")
@export var panel: PanelContainer
@export var label: ScrollingLabel

var accum_: float = 0.0


func _set_display_text(value: String) -> void:
	display_text = value
	label.base_text = display_text + " "


func _ready() -> void:
	scale.y = 0.0
	label.scrolling_speed = randf_range(32.0, 128.0)


func _process(dt: float) -> void:
	dt *= Data.pause_scale
	
	if destroy:
		scale.y = maxf(0.0, scale.y - dt * alert_cadence)
		if scale.y <= 0.0:
			queue_free()
	else:
		scale.y = minf(1.0, scale.y + dt * alert_cadence)
	
	accum_ = fmod(accum_ + alert_cadence * dt, 1.0)
	var a := (sin(TAU * accum_) + 1.0) / 2.0
	panel.self_modulate = lerp(Color.WHITE, Color.BLACK, a)
	panel.self_modulate.a = 0.8
	
