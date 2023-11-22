class_name Projectile extends ShapeCast2D

@export var lifetime := 1.
@export var max_hits := 1

@export_group('Damage')
@export var damage := 1
@export var knockback := 1.0
@export var can_cut := false

@export_group('Movement')
@export var time := 1.
@export var position_as_speed := false
@export var position_over_time: Curve
@export var offset_over_time: Curve


@onready var starting_position := position
@onready var direction := transform.basis_xform(Vector2.RIGHT)
@onready var perpendicular := transform.basis_xform(Vector2.UP)


var age := 0.
var distance := 0.


func _physics_process(delta: float) -> void:
	age += delta
	var ratio := age / time
	if age >= lifetime:
		queue_free()
		return
	
	var old_distance := distance 
	if position_as_speed:
		distance += position_over_time.sample_baked(ratio) * 16 * delta
	else:
		distance = position_over_time.sample_baked(ratio) * 16
	var distance_delta := distance - old_distance
	
	var offset := 0.0
	if offset_over_time:
		offset = offset_over_time.sample_baked(ratio) * 16
	
	var target := starting_position + direction*distance + perpendicular*offset
	var motion := target - position
	target_position = (Vector2.RIGHT * distance_delta) + (Vector2.UP * offset)
	
	for collision in collision_result:
		var has_hit := deal_damage(collision.collider)
		if has_hit:
			Particles.emit_impact(collision.point)
			max_hits -= 1
			if max_hits <= 0:
				queue_free()
				return
	
	position = target


func deal_damage(body: Node2D) -> bool:
	var has_hit = false
	if body.has_method('take_damage'):
		if body.call('take_damage', damage, Vector2.from_angle(rotation) * knockback):
			has_hit = true
	
	if can_cut and body.has_method('take_cut'):
		if body.call('take_cut', Vector2.from_angle(rotation)):
			has_hit = true
	
	return has_hit
