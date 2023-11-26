class_name Die extends Node2D


func trigger() -> void:
	if owner.has_method('die'):
		owner.call('die')
