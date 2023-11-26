class_name SimpleTrail extends Line2D


@export var interval := 0

var tick := 0

func _ready() -> void:
	clear_points()
	add_point(owner.global_position)
	add_point(owner.global_position)


func _physics_process(delta: float) -> void:
	tick += 1
	
	if tick <= interval: return
	tick = 0
	
	set_point_position(1, get_point_position(0))
	set_point_position(0, owner.global_position)
