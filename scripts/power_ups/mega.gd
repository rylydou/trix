extends PowerUp


var PROJECTILE: PackedScene = preload('res://scenes/projectiles/basic.tscn')


func get_name() -> String:
	return 'Mega'


func _pressed() -> void:
	assert(is_instance_valid(player))
	
	print('shoot')
