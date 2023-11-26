extends Node

@export var target: Node2D
@export var time := 1.0
@export var curve: Curve
@export var turn_max := 1.0

var age := 0.0


func _ready() -> void:
	if not target:
		target = get_parent()


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target): return
	
	age += delta
	
	var fract := fmod(age, time)
	var amount := curve.sample_baked(fract)
	
	if is_instance_valid(Player.current):
		var current_angle = fposmod(target.rotation, 2 * PI)

		var angle_to_player = target.global_position.angle_to_point(Player.current.global_position)

		var target_angle = fposmod(angle_to_player, 2 * PI)

		var difference = fposmod(target_angle - current_angle + 3 * PI, 2 * PI) - PI

		var rotation_amount = clamp(abs(difference), 0, turn_max) * sign(difference)
		target.rotate(rotation_amount * delta)
		
	target.position += Vector2.from_angle(target.rotation) * amount
