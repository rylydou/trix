class_name Group extends Node2D

@export var parallel := false


func trigger() -> void:
	for child in get_children():
		if not child.visible: continue
		
		if parallel:
			child.trigger()
		else:
			await child.trigger()
