class_name HUDPrecession
extends HUDComponent

@export var player: PlayerMech
@export var exceed_timer: float = 1.0

@export_group("Internal")
@export var player_icon: TextureRect
@export var alert_notifier: Label
@export var fall_progress: ProgressBar

var fall_progress_: float = 0.0
var stored_value_: float = 0.0
var alarm_value_: float = 0.0
var fall_over_timer_: float = 0.0
var fall_reduction_: float = 0.0


func _ready() -> void:
	queue_redraw()


func _process(dt: float) -> void:
	if Data.disabled:
		visible = false
		return
	
	var p := player.get_precession()
	stored_value_ = clampf(lerpf(stored_value_, p, 0.01), -PI / 2.0, PI / 2.0)
	player_icon.rotation = stored_value_
	
	alarm_value_ = fmod(alarm_value_ + dt * 2.0 * (1.0 + 2.0 * fall_progress_), 1.0)
	
	if absf(p) > PI / 6.0:
		fall_reduction_ = 0.0
		fall_progress_ = minf(1.0, fall_progress_ + dt / 4.0)
		var mag := (sin(TAU * alarm_value_) + 1.0) / 2.0
		alert_notifier.self_modulate = lerp(Color.WHITE, Color.BLACK, mag)
		alert_notifier.add_theme_constant_override("font_outline", floori(mag * 16.0))
	else:
		fall_reduction_ += dt
		fall_progress_ = maxf(0.0, fall_progress_ - dt * fall_reduction_)
		alert_notifier.self_modulate = Color.BLACK
	
	fall_progress.value = fall_progress_
	is_capacity_exceeded = fall_progress_ >= 1.0
	
	if fall_progress_ >= 1.0:
		fall_over_timer_ += dt
		if fall_over_timer_ >= exceed_timer:
			Data.disabled = true
	else:
		fall_over_timer_ = 0.0


func _draw() -> void:
	draw_line(Vector2(0, size.y), Vector2(size.x, size.y), Color.WHITE, 3.0)
	draw_line(Vector2(size.x / 2.0, 0.0), Vector2(size.x / 2.0, size.y), Color.WHITE, 3.0)
