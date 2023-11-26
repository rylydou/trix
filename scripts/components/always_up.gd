class_name AlwaysUp extends Node2D


func _ready() -> void:
	top_level = true


func _physics_process(delta) -> void:
	rotation = 0
	position = owner.global_position
	modulate = owner.modulate
