class_name Level extends Node2D


@export var time_limit := 20.0
@onready var time_ticks := time_limit * 60


var tick := 0
var time := 0.0
var enemy_count := 0
var no_enemies_timestamp := 0.0


func _ready() -> void:
	var scene: PackedScene = preload('res://scenes/level_background.tscn')
	add_child(scene.instantiate())


func _physics_process(delta: float) -> void:
	tick += 1
	time += delta
	
	enemy_count = get_tree().get_nodes_in_group(&'enemy').size()
	
	if enemy_count == 0:
		no_enemies_timestamp = time
	
	var time_remaining_ratio := 1.0 - time / time_limit
	
	$'Level Background/Timer'.material.set_shader_parameter('radial_fill', time_remaining_ratio)
