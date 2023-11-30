class_name Level extends Node2D


static var current: Level


@export var time_limit := 20.0
@export var win_delay_ticks := 30
@export var attempts_to_skip := 3.0

@export var power_pools: Array[PowerPool] = []


@onready var time_limit_ticks := time_limit * 60
@onready var ticks_to_skip := attempts_to_skip * time_limit * 60


var tick := 0
var time := 0.0
var enemy_count := 0
var no_enemies_ticks := 0


func _enter_tree() -> void:
	current = self
	
	var timer_scene: PackedScene = preload('res://scenes/timer.tscn')
	add_child(timer_scene.instantiate())
	
	for pool in power_pools:
		pool.reset()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('cheat_refill_timer'):
		tick = 0
		time = 0


func _physics_process(delta: float) -> void:
	tick += 1
	time += delta
	var time_remaining_ratio := 1.0 - time / time_limit
	
	# Set timer sprite
	var timer_material: ShaderMaterial = $'Timer'.material
	timer_material.set_shader_parameter('radial_fill', time_remaining_ratio)
	
	$'Timer/Label'.text = '%2.2f' % [max(time_limit - time, 0)]
	
	enemy_count = get_tree().get_nodes_in_group(&'enemy').size()
	
	if enemy_count == 0:
		no_enemies_ticks += 1
	else:
		no_enemies_ticks = 0
	
	# -----
	
	# If no enemies on screen for a certain amount of time then you win!
	if no_enemies_ticks > win_delay_ticks:
		Game.win()
		return
	
	# If enemies are on screen and over time then fail.
	if enemy_count > 0 and tick > time_limit_ticks:
		Game.fail_out_of_time()
		return
