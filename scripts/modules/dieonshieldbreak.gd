extends Node

@export var target: Node2D

func _ready() -> void:
	if not target:
		target = get_parent()
	target.shield_broken.connect(_shield_broken)

func _shield_broken() -> void:
	target._death()
	
