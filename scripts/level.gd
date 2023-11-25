class_name Level extends Node2D


@export var time_limit := 20.0
@onready var time_limit_ticks := time_limit * 60

@export var win_delay_ticks := 30


var tick := 0
var time := 0.0
var enemy_count := 0
var no_enemies_ticks := 0


func _ready() -> void:
	var timer_scene: PackedScene = preload('res://scenes/timer.tscn')
	add_child(timer_scene.instantiate())


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
