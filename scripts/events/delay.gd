class_name Delay extends Node2D

@export var frames := 30

func trigger() -> void:
	var t := create_tween()
	t.tween_callback(func():).set_delay(frames/60.)
	await t.finished
