extends Node


@export var speed := 2.0
@export var curve: Curve2D

var offset := 0.0


func _enter_tree() -> void:
	if not curve:
		curve = owner.get_parent().curve
	offset = curve.get_closest_offset(owner.position)
	
	tick()

func _physics_process(delta: float) -> void:
	tick()


func tick() -> void:
	offset += speed
	if offset > curve.get_baked_length():
		offset = 0
	
	owner.position = curve.sample_baked(offset)
