class_name Trail extends Line2D


@export var max_trail_length := 10


func _ready() -> void:
	clear_points()


func _physics_process(delta: float) -> void:
	add_point(owner.global_position, 0)
	if points.size() > max_trail_length:
		remove_point(get_point_count() - 1)
