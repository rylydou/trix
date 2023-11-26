class_name Rotator extends Node

@export var target: Node2D
@export var time := 1.0
@export var curve: Curve
@export var is_additive := true


var age := 0.0


func _ready() -> void:
	if not target:
		target = get_parent()


func _physics_process(delta: float) -> void:
	age += delta
	
	var fract := fmod(age, time)
	var amount := curve.sample_baked(fract)
	
	if is_additive:
		target.rotation_degrees += amount
	else:
		target.rotation_degrees = amount
