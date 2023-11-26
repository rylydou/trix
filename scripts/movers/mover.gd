class_name Mover extends Node


@export var target: Node2D
@export var period := 1.0
@export var curve: Curve
@export var only_move_on_path := false


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
		offset = fmod(offset, path.get_baked_length())
		target.position = path.sample_baked(offset)
	elif not only_move_on_path:
		target.position += Vector2.from_angle(target.rotation) * speed
