extends Enemy


static var first_smallest := true


@export var size := 4


var scene := PackedScene.new()


func _ready() -> void:
	scene.pack(self)
	
	var scale := 1. / (5 - size)
	$'Circle'.material.set_shader_parameter('radius', scale)
	$'Collision'.shape.radius = 128 * scale
	
	# shield_hp = size * 2
	shield_hp = size
	
	if size == 4:
		first_smallest = true
	
	if size == 1 and first_smallest:
		first_smallest = false
		power_up_id = 'mega'
	
	super._ready()


func _shield_broken() -> void:
	if size <= 1:
		return super._shield_broken()
	
	var count := 3
	# if size == 4:
		# count = 4
		
	var rotation_basis := randf_range(0, 2 * PI)
	
	for i in range(count):
		var clone: Node2D = scene.instantiate()
		clone.size = size - 1
		clone.invuln_ticks = 15
		clone.position = position
		clone.rotation = (2 * PI / count * i) + rotation_basis
		
		get_parent().add_child(clone)
	
	super.die()
