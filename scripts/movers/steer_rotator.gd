class_name SteerRotator extends Node


@export var target: Node2D
@export var turn_speed := 1.0


func _ready() -> void:
	if not target:
		target = get_parent()


func _physics_process(delta: float) -> void:
	var player := Player.current
	
	if not is_instance_valid(player): return
	
	var angle_to_player := target.global_position.angle_to_point(player.global_position)
	
	target.global_rotation = rotate_toward(target.global_rotation, angle_to_player, turn_speed)
