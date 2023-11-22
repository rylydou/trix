class_name CurveMover extends Node

@export var target: Node2D
@export var time := 1.0
@export var curve: Curve


var age := 0.0


func _ready() -> void:
	if not target:
		target = get_parent()


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target): return
	
	age += delta
	
	var fract := fmod(age, time)
	var amount := curve.sample_baked(fract)
	
	target.position += Vector2.from_angle(target.rotation) * amount
