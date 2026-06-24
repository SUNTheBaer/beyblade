class_name Monster
extends StaticBody2D

@export var hp: float = 1.0: set = _set_hp
@export var player: PlayerMech
@export var body: AnimatedSprite2D
@export var shadow: AnimatedSprite2D
@export var target_velocity: Vector2
@export var impact_velocity: Vector2


func _set_hp(value: float) -> void:
	hp = clampf(value, 0.0, 1.0)
	if hp <= 0.0:
		Data.victory = true


func _ready() -> void:
	EntityManager.subscribe(self, 480.0)
	body.play()


func _process(dt: float) -> void:
	if not is_zero_approx(impact_velocity.length()):
		global_position += impact_velocity * dt
		impact_velocity *= 0.9
		body.animation = "default"
	else:
		if not is_zero_approx(target_velocity.length()):
			body.animation = "walk"
			global_position += target_velocity * dt
		else:
			body.animation = "default"
	
	shadow.animation = body.animation
	shadow.frame = body.frame
	shadow.global_position = global_position + Data.sun_direction * 32.0
