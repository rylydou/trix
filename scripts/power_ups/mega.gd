extends PowerUp


var max_shots := 3
var projectile: PackedScene = preload('res://scenes/projectiles/player/mega_bullet.tscn')
var fire_cooldown := 10
var recoil_ticks := 4
var recoil_force := 10.0


var shots := max_shots
var cooldown := -1


func get_name() -> String:
	return 'Mega'


func get_fill() -> float:
	return float(shots) / max_shots


func _tick(delta: float) -> void:
	cooldown -= 1


func _pressed() -> void:
	if cooldown > 0: return
	cooldown = fire_cooldown
	shots -= 1
	if shots <= 0:
		kill_me_pls = true
	
	shot_projectile(projectile.instantiate())
	player.apply_force(Vector2.from_angle(player.rotation) * -recoil_force, recoil_ticks)
