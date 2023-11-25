extends CurveMover

@export var life:= 1.0

func _physics_process(delta):
	life -= delta
	
	if life <= 0:
		target._death()
	
	var pos := target.global_position
	var direction := Vector2.from_angle(target.rotation)
	var bounds := Game.bounds
	if abs(pos.x) > bounds.x:
		target._death()
	if abs(pos.y) > bounds.y:
		target._death()
	super._physics_process(delta)
