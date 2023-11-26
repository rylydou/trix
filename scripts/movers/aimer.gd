class_name Aimer extends Node


@export var target: Node2D
@export var turn_speed := 0.0


func _ready() -> void:
	if not target:
		target = get_parent()


func _physics_process(delta: float) -> void:
	var player := Player.current
	
	if not is_instance_valid(player): return
	
	var angle_to_player := target.global_position.angle_to_point(player.global_position)
	
	if turn_speed == 0:
		target.global_rotation = angle_to_player
		return
	
	target.global_rotation = rotate_toward(target.global_rotation, angle_to_player, deg_to_rad(turn_speed))
