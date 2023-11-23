class_name EdgeBouncer extends Node


@export var target: Node2D


func _ready() -> void:
	if not target:
		target = get_parent()


func _process(delta: float) -> void:
	if not is_instance_valid(target): return
	
	var pos := target.global_position
	var direction := Vector2.from_angle(target.rotation)
	var bounds := Game.bounds
	if abs(pos.x) > bounds.x and sign(direction.x) == sign(pos.x):
		direction.x = -direction.x
	if abs(pos.y) > bounds.y and sign(direction.y) == sign(pos.y):
		direction.y = -direction.y
	
	target.rotation = direction.angle()
