extends Node

@export var target: Node2D
@export var child_scene: PackedScene
@export var spawn_cooldown:= 5.0
@export var spawn_amount:= 2
@onready var til_spawn = spawn_cooldown

func _ready() -> void:
	if not target:
		target = get_parent()

func _physics_process(delta):
	til_spawn -= delta
	if til_spawn <= 0:
		til_spawn = spawn_cooldown
		for x in range(0, spawn_amount):
			var child = child_scene.instantiate()
			child.global_position = target.global_position
			get_tree().current_scene.add_child(child)
