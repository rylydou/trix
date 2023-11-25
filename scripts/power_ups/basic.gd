extends PowerUp

var projectile: PackedScene = preload('res://scenes/projectiles/basic_bullet.tscn')
var fire_cooldown := 5
var recoil_ticks := 5
var recoil_force := 6.0


var cooldown := -1


func get_name() -> String:
	return 'Basic'


func get_fill() -> float:
	return -1.0


func _tick(delta: float) -> void:
	cooldown -= 1


func _down() -> void:
	if cooldown > 0: return
	cooldown = fire_cooldown
	
	shot_projectile(projectile.instantiate())
	player.apply_force(Vector2.from_angle(player.rotation) * -recoil_force, recoil_ticks)
