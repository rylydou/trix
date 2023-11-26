extends Node


@export var target: Node2D
@export var proj_scene: PackedScene
@export var cooldown:= 5.0
@export var tween_shots:= .25
@export var amount:= 2
@onready var til_shoot = cooldown

var til_shots = []

func _ready() -> void:
	if not target:
		target = get_parent()
	for x in range(0, amount):
		til_shots.append(100.0)
		print_debug(x)

func _physics_process(delta):
	til_shoot -= delta
	
	if til_shoot <= 0:
		print_debug("Shooting")
		
		for x in range(0, amount):
			til_shots[x] = tween_shots * x
			
		til_shoot = cooldown

	for x in range(0, amount):
		til_shots[x] -= delta
		if til_shots[x] <= 0:
			til_shots[x] = 100.0
			if is_instance_valid(Player.current):
				var proj = proj_scene.instantiate()
				proj.global_position = target.global_position
				proj.rotation = target.global_position.angle_to_point(Player.current.global_position)
				get_tree().current_scene.add_child(proj)
