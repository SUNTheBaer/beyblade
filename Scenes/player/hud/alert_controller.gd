class_name HUDAlertController
extends Control

@export var hud: Control
@export var alert_scene: PackedScene
@export var player_area := 200.0
@export var alert_area := Vector2(128, 128)

var components_: Array[HUDComponent]
var alerts_: Dictionary[HUDComponent, HUDAlert]


func _ready() -> void:
	_scan_children(hud)


func _process(dt: float) -> void:
	dt *= Data.pause_scale
	if Data.victory:
		modulate.a = maxf(0.0, modulate.a - dt)


func _scan_children(value: Control) -> void:
	if value is HUDComponent:
		value.capacity_exceeded.connect(_increment_alert.bind(value))
		value.within_parameters.connect(_decrement_alert.bind(value))
	for node in value.get_children():
		if node is Control:
			_scan_children(node)


func _increment_alert(comp: HUDComponent) -> void:
	if comp in components_:
		return
	components_.push_back(comp)
	var a := alert_scene.instantiate() as HUDAlert
	a.display_text = comp.alert_display_text
	a.alert_cadence = randf_range(4.0, 16.0)
	add_child(a)
	
	var angle := randf_range(0.0, TAU)
	
	a.global_position = Vector2(
		get_viewport_rect().size.x / 2.0 + cos(angle) * maxf(player_area, randf() * alert_area.x),
		get_viewport_rect().size.y / 2.0 + sin(angle) * maxf(player_area, randf() * alert_area.y))
	alerts_[comp] = a


func _decrement_alert(comp: HUDComponent) -> void:
	if comp not in components_:
		return
	components_.erase(comp)
	var a := alerts_.get(comp) as HUDAlert
	if null != a:
		a.destroy = true
	alerts_.erase(comp)
