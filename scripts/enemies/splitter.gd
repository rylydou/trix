extends Enemy


@export var size := 4


func _ready() -> void:
	var radius := size * 16
	$'Circle'.material.set_shader_parameter('', 1. / size)
	$'Collision'.shape.radius = radius


func _shield_broken() -> void:
	if size == 1:
		return super._shield_broken()
	
	var clone1 = duplicate()
	var clone2 = duplicate()
	
	clone1.size = size - 1
	clone2.size = size - 1
	
	clone1.invuln_ticks = 15
	clone2.invuln_ticks = 15
	
	get_tree().current_scene.add_child(clone1)
	get_tree().current_scene.add_child(clone2)
	
	super._death()
