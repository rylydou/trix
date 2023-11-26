@icon('res://content/icons/delay.svg')
class_name Delay extends Node2D


@export var ticks := 30


func trigger() -> void:
	var t := create_tween()
	t.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	t.tween_callback(func():).set_delay(ticks/60.)
	await t.finished
