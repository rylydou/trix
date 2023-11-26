extends Node

@export var explosion_amount:= 4
@export var proj_scene: PackedScene
@export var target: Node2D


func _ready() -> void:
	if not target:
		target = get_parent()
	target.shield_broken.connect(_shield_broken)

func _shield_broken() -> void:
	var angle = randf() * 2 * PI
	
	for x in range(0,explosion_amount):
		var proj = proj_scene.instantiate()
		proj.rotation = angle + (2 * PI / explosion_amount * x)
		proj.global_position = target.global_position
		get_tree().current_scene.add_child(proj)
	
