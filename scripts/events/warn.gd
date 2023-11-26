class_name Warn extends Delay


@export var warn_ticks := 30


func _trigger() -> void:
	Particles.emit_warn(global_position)
	await _trigger()
