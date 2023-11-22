extends Line2D


func _ready() -> void:
	clear_points()
	add_point(owner.global_position)
	add_point(owner.global_position)
	add_point(owner.global_position)


func _physics_process(delta: float) -> void:
	set_point_position(2, get_point_position(1))
	set_point_position(1, get_point_position(0))
	set_point_position(0, owner.global_position)
