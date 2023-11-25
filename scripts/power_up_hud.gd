extends MeshInstance2D


func _physics_process(delta: float) -> void:
	if is_instance_valid(Player.current) and not Player.current.power_up:
		hide()
		return
	
	show()
	
	$'Label'.text = Player.current.power_up.get_name()
	
	var fill := Player.current.power_up.get_fill()
	var material: ShaderMaterial = self.material
	material.set_shader_parameter('radial_fill', fill)
