class_name EdgeBouncer extends Node


@export var target: Node2D


func _ready() -> void:
	if not target:
		target = get_parent()


func _process(delta: float) -> void:
	if not is_instance_valid(target): return
	
	var direction := Vector2.from_angle(target.rotation)
	var bounds := Game.bounds
	if abs(target.global_position.x) > bounds.x:
		direction.x = -direction.x
	if abs(target.global_position.y) > bounds.y:
		direction.y = -direction.y
	
	target.rotation = direction.angle()
