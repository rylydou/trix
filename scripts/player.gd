class_name Player extends CharacterBody2D


@export_group('Movement')
@export var normal_friction := 0.9
@export var firing_friction := 0.99

@export_group('Shooting')
@export var aim_length_limit := 96.0
@export var ticks_btw_shots := 3
@export var projectile: PackedScene

@export_group('Trail')
@export var max_dir_history := 10
@export var dir_history_weight_curve: Curve


@onready var dot_node: Node2D = %'Dot'
@onready var shoot_marker: Marker2D = %'Shoot Marker'


var motion := Vector2.ZERO
var aim_vector := Vector2.ZERO
var direction_history := PackedVector2Array()
var fire_cooldown := -1


func _ready() -> void:
	show()

func _physics_process(delta: float) -> void:
	var input_shoot := Input.is_action_pressed('shoot')
	var input_aim := Input.is_action_pressed('aim')
	
	# Movement
	motion = Game.mouse_delta
	if input_aim:
		aim_vector += motion
		aim_vector = aim_vector.limit_length(aim_length_limit)
		motion = Vector2.ZERO
	else:
		aim_vector = Vector2.ZERO
	
	move_and_collide(motion)
	
	var friction = firing_friction if fire_cooldown > 0 else normal_friction
	velocity *= friction
	move_and_slide()
	
	# Direction and aiming
	direction_history.insert(0, Game.mouse_delta)
	if direction_history.size() > max_dir_history:
		direction_history.remove_at(direction_history.size() - 1)
	
	var direction = Calc.get_avg_dir(direction_history, dir_history_weight_curve)
	if input_aim:
		direction = aim_vector
	if Game.mouse_delta != Vector2.ZERO:
		rotation = direction.angle()
	
	# Shooting
	fire_cooldown -= 1
	if input_shoot:
		if fire_cooldown <= 0:
			fire_cooldown = ticks_btw_shots
			shoot()
	
	
	# Screen bounds and wrap
	var bounds: Vector2 = Game.bounds
	position.x = wrapf(position.x, -bounds.x, bounds.x)
	position.y = wrapf(position.y, -bounds.y, bounds.y)
	
	# Dot crosshair
	dot_node.position = global_position + aim_vector
	
	Game.mouse_delta = Vector2.ZERO


func shoot(angle := 0.0) -> void:
	var proj := projectile.instantiate()
	proj.global_position = shoot_marker.global_position
	proj.global_rotation = shoot_marker.global_rotation + angle
	get_tree().current_scene.add_child(proj)
	
	velocity -= Vector2.from_angle(global_rotation) * 10
