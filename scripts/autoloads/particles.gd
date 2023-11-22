extends Node2D


@export var impact: GPUParticles2D
@export var shield_break: GPUParticles2D
@export var kill: GPUParticles2D
@export var warn: GPUParticles2D


func restart_all() -> void:
	impact.restart()
	impact.emitting = false
	shield_break.restart()
	shield_break.emitting = false
	kill.restart()
	kill.emitting = false
	warn.restart()
	warn.emitting = false


func emit_impact(position: Vector2) -> void:
	const flags := GPUParticles2D.EMIT_FLAG_POSITION
	var xform := Transform2D(0, Vector2.ZERO, 0, position)
	impact.emit_particle(xform, Vector2.ZERO, Color.WHITE, Color.WHITE, flags)

func emit_shield_break(position: Vector2) -> void:
	const flags := GPUParticles2D.EMIT_FLAG_POSITION
	var xform := Transform2D(0, Vector2.ZERO, 0, position)
	shield_break.emit_particle(xform, Vector2.ZERO, Color.WHITE, Color.WHITE, flags)

func emit_kill(position: Vector2) -> void:
	const flags := GPUParticles2D.EMIT_FLAG_POSITION
	var xform := Transform2D(0, Vector2.ZERO, 0, position)
	# for index in range(16):
	kill.emit_particle(xform, Vector2.ZERO, Color.WHITE, Color.WHITE, flags)

func emit_warn(position: Vector2) -> void:
	const flags := GPUParticles2D.EMIT_FLAG_POSITION
	var xform := Transform2D(0, Vector2.ZERO, 0, position)
	warn.emit_particle(xform, Vector2.ZERO, Color.WHITE, Color.WHITE, flags)
