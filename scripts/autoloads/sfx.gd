extends Node


@export var death: Array[AudioStream] = []
@export var respawn: Array[AudioStream] = []
@export var hit: Array[AudioStream] = []
@export var shield_break: Array[AudioStream] = []
@export var hit_ineffective: Array[AudioStream] = []
@export var cut: Array[AudioStream] = []


func play_death(position: Vector2) -> void:
	var p := SoundManager.play_sound(death.pick_random(), 'SFX')
	p.volume_db = 0.0
	p.pitch_scale = randf_range(1.0, 1.0)


func play_respawn() -> void:
	var p := SoundManager.play_sound(respawn.pick_random(), 'SFX')
	p.volume_db = 0.0
	p.pitch_scale = randf_range(1.0, 1.0)


func play_hit(position: Vector2, damage := 0) -> void:
	var p := SoundManager.play_sound(hit.pick_random(), 'SFX')
	p.volume_db = -6.0
	p.pitch_scale = randf_range(0.9, 1.1)


func play_shield_break(position: Vector2) -> void:
	var p := SoundManager.play_sound(shield_break.pick_random(), 'SFX')
	p.volume_db = -0.0
	p.pitch_scale = randf_range(0.9, 1.1)


func play_hit_ineffective(position: Vector2) -> void:
	var p := SoundManager.play_sound(hit_ineffective.pick_random(), 'SFX')
	p.volume_db = -12.0
	p.pitch_scale = randf_range(0.9, 1.1)


func play_cut(position: Vector2) -> void:
	var p := SoundManager.play_sound(cut.pick_random(), 'SFX')
	p.volume_db = -0.0
	p.pitch_scale = randf_range(0.9, 1.1)
