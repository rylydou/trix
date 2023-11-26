class_name CurveMover extends Node


@export var target: Node2D
@export var period := 1.0
@export var curve: Curve


var age := 0.0
var path: Curve2D
var offset := 0.0


func _ready() -> void:
	if not target:
		target = get_parent()
	
	var parent := target.get_parent()
	if parent is Path2D:
		path = parent.curve
	
	if path:
		offset = path.get_closest_offset(target.position)
		
		tick(0)


func _physics_process(delta: float) -> void:
	tick(delta)


func tick(delta: float) -> void:
	if not is_instance_valid(target): return
		
	age += delta
	
	var fract := fmod(age, period)
	var speed := curve.sample_baked(fract)
	
	if path:
		offset += speed
		target.position = path.sample_baked(offset)
	else:
		target.position += Vector2.from_angle(target.rotation) * speed
