class_name PowerUp extends RefCounted


var player: Player
var kill_me_pls := false


func get_name() -> String:
	return 'Unknown'


func get_fill() -> float:
	return 1.0



func _tick(delta: float) -> void:
	pass


func _pressed() -> void:
	pass

func _down() -> void:
	pass

func _released() -> void:
	pass


func shot_projectile(proj: Node2D, rotation_offset: float = 0) -> void:
	proj.position = player.shoot_marker.global_position
	proj.rotation = player.shoot_marker.global_rotation + rotation_offset
	player.get_tree().current_scene.add_child(proj)
