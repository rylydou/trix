class_name Enemy extends CharacterBody2D

signal shield_broken()
signal killed()


@export var shield_hp := 1
@export var friction := 0.99
@export var invuln_ticks := 0


func _init() -> void:
	rotation = randf_range(0, 2*PI)


func _ready() -> void:
	set_shield(shield_hp)


func _physics_process(delta: float) -> void:
	velocity *= friction
	move_and_slide()
	
	if invuln_ticks > 0:
		invuln_ticks -= 1


func set_shield(new_hp: int) -> void:
	var had_shield = self.shield_hp > 0
	var has_shield = new_hp > 0
	self.shield_hp = new_hp
	
	if had_shield and not has_shield:
		_shield_broken()
	
	modulate = Game.bad_shield_color if has_shield else Game.bad_vulnerable_color
	set_collision_layer_value(4, has_shield)


func take_damage(damage: int, knockback: Vector2) -> bool:
	if invuln_ticks > 0: return false
	if shield_hp <= 0: return true
	
	set_shield(shield_hp - damage)
	velocity += knockback
	return true


func take_cut(dir: Vector2) -> bool:
	if invuln_ticks > 0: return false
	if shield_hp > 0: return false
	
	_death()
	return true


func _shield_broken() -> void:
	shield_broken.emit()
	Particles.emit_shield_break(global_position)


func _death() -> void:
	killed.emit()
	queue_free()
	Particles.emit_kill(global_position)
