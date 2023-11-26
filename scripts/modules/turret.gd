extends Node


@export var target: Node2D
@export var proj_scene: PackedScene
@export var cooldown:= 5.0
@onready var til_shoot = cooldown

func _ready() -> void:
	if not target:
		target = get_parent()

func _physics_process(delta):
	til_shoot -= delta
	if til_shoot <= 0:
		til_shoot = cooldown
		if is_instance_valid(Player.current):
			var proj = proj_scene.instantiate()
			proj.global_position = target.global_position
			proj.rotation = target.global_position.angle_to_point(Player.current.global_position)
			get_tree().current_scene.add_child(proj)
