extends Enemy


@export var size := 4


var scene := PackedScene.new()


func _ready() -> void:
	scene.pack(self)
	
	var scale := 1. / (5 - size)
	$'Circle'.material.set_shader_parameter('radius', scale)
	$'Collision'.shape.radius = 128 * scale
	
	shield_hp = size * 2
	
	super._ready()


func _shield_broken() -> void:
	if size <= 1:
		return super._shield_broken()
	
	var count := 2
	if size == 4:
		count = 4
	
	for i in range(count):
		var clone: Node2D = scene.instantiate()
		clone.size = size - 1
		clone.invuln_ticks = 15
		clone.position = position
		
		get_parent().add_child(clone)
	
	super._death()
