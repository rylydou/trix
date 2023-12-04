class_name Enemy extends CharacterBody2D


signal shield_broken()
signal killed()


@export var shield_hp := 1
@export var invuln_ticks := 0
@export var friction := 0.99
@export var warn_radius := 16.0
@export var die_on_shield_break := false

@export var power_up_id := &''


var power_up: PowerUp


func _ready() -> void:
	set_shield(shield_hp)
	
	if not power_up_id.is_empty():
		power_up = Consts.powers_ups[power_up_id].new()
		var label: Label = Consts.scn_power_up_label.instantiate()
		label.text = power_up.get_name()[0]
		add_child(label)


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
	
	modulate = Calc.get_color(new_hp)
	
	set_collision_layer_value(4, has_shield)


func take_damage(damage: int, knockback: Vector2) -> bool:
	if invuln_ticks > 0: return false
	if shield_hp <= 0:
		SFX.play_hit_ineffective(position)
		return true
	
	SFX.play_hit(position)
	set_shield(shield_hp - damage)
	velocity += knockback
	return true


func take_cut(dir: Vector2) -> bool:
	if invuln_ticks > 0: return false
	if shield_hp > 0: return false
	
	die()
	return true


func _shield_broken() -> void:
	shield_broken.emit()
	Particles.emit_shield_break(global_position)
	
	if die_on_shield_break:
		die()


func die() -> void:
	killed.emit()
	queue_free()
	Particles.emit_kill(global_position)
	
	if power_up and is_instance_valid(Player.current):
		Player.current.set_power_up(power_up)
