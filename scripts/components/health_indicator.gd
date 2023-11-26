class_name HealthIndicator extends AlwaysUp


var starting_health: int


func _ready() -> void:
	super._ready()
	
	starting_health = owner.shield_hp


func _physics_process(delta) -> void:
	super._physics_process(delta)
	
	if owner.shield_hp <= 0:
		hide()
		return
	
	var fill := float(owner.shield_hp) / starting_health
	var material: ShaderMaterial = self.material
	material.set_shader_parameter('radial_fill', fill)
	rotation = 0
	position = get_parent().global_position
	modulate = owner.modulate
