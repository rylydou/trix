class_name Player extends CharacterBody2D


static var current: Player


@export_group('Movement')
@export var normal_friction := 0.9
@export var firing_friction := 0.99

@export_group('Shooting')
@export var aim_length_limit := 96.0

@export_group('Trail')
@export var max_dir_history := 10
@export var dir_history_weight_curve: Curve


@onready var dot_node: Node2D = %'Dot'
@onready var shoot_marker: Marker2D = %'Shoot Marker'


var power_up: PowerUp
var base_power: PowerUp = Consts.power_up_base.new()


var motion := Vector2.ZERO
var aim_vector := Vector2.ZERO
var direction_history := PackedVector2Array()
var slippery_ticks := -1


func _enter_tree() -> void:
	current = self
	show()
	base_power.player = self
	
	# set_power_up(Consts.powers_ups['mega'].new())


func _physics_process(delta: float) -> void:
	var input_aim := Input.is_action_pressed('aim')
	var mouse_delta: Vector2 = Game.mouse_delta
	Game.mouse_delta = Vector2.ZERO
	
	# Movement
	motion = mouse_delta
	if input_aim:
		aim_vector += motion
		aim_vector = aim_vector.limit_length(aim_length_limit)
		motion = Vector2.ZERO
	else:
		aim_vector = Vector2.ZERO
	
	move_and_collide(motion)
	
	var friction = firing_friction if slippery_ticks > 0 else normal_friction
	velocity *= friction
	move_and_slide()
	
	# Direction and aiming
	direction_history.insert(0, mouse_delta)
	if direction_history.size() > max_dir_history:
		direction_history.remove_at(direction_history.size() - 1)
	
		if input_aim:
			rotation = aim_vector.angle()
		else:
			var direction = Calc.get_avg_dir(direction_history, dir_history_weight_curve)
			if mouse_delta != Vector2.ZERO:
				rotation = direction.angle()
	
	# Screen bounds and wrap
	var bounds: Vector2 = Game.bounds
	position.x = wrapf(position.x, -bounds.x, bounds.x)
	position.y = wrapf(position.y, -bounds.y, bounds.y)
	
	# Dot crosshair
	dot_node.position = global_position + aim_vector
	
	# Power Up
	var input_shoot_pressed := Input.is_action_just_pressed('shoot')
	var input_shoot_down := Input.is_action_pressed('shoot')
	var input_shoot_released := Input.is_action_just_released('shoot')
	
	if power_up and power_up.kill_me_pls:
		power_up = null
	
	base_power._tick(delta)
	if power_up:
		power_up._tick(delta)
	
	var current_power := power_up if power_up else base_power
	
	if input_shoot_pressed:
		current_power._pressed()
	if input_shoot_down:
		current_power._down()
	if input_shoot_released:
		current_power._released()


func apply_force(vector: Vector2, slippery_ticks: int) -> void:
	velocity += vector
	if slippery_ticks > self.slippery_ticks:
		self.slippery_ticks = slippery_ticks


func set_power_up(power_up: PowerUp) -> void:
	power_up.player = self
	self.power_up = power_up
