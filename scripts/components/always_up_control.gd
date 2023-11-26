extends Control


func _ready() -> void:
	top_level = true


func _physics_process(delta) -> void:
	rotation = 0
	position = get_parent().global_position - size/2
	modulate = get_parent().modulate
