class_name MazeGen extends Node2D


@export var width := 16
@export var height := 9

@export var mazes_image: Image


func _ready() -> void:
	var blueprint_node: StaticBody2D = get_child(0)
	remove_child(blueprint_node)
	
	for y in range(height):
		for x in range(width):
			var clone: StaticBody2D = blueprint_node.duplicate()
			
			clone.position = (Vector2(x + .5, y + .5) * (Game.bounds * 2) / Vector2(width, height)) - Game.bounds
			
			add_child(clone)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('debug'):
		debug_generate()


func debug_generate() -> void:
		generate(randi_range(0, 3), 0, randi_range(0, 1) == 0, randi_range(0, 1) == 0)


func generate(maze_x: int, maze_y: int, flip_x: bool, flip_y: bool) -> void:
	var offset_x := maze_x * width
	var offset_y := maze_y * height
	
	for y in range(height):
		for x in range(width):
			var px := offset_x + (width - 1 - x if flip_x else x)
			var py := offset_y + (height - 1 - y if flip_y else y)
			if px < 0:
				prints('x', px, offset_x, x, flip_x)
				continue
			if py < 0:
				prints('y', py, offset_y, y, flip_y)
				continue
			var pix := mazes_image.get_pixel(px, py)
			var state := pix.a != 0
			set_cell(x, y, state)


func set_cell(x: int, y: int, enabled: bool) -> void:
	var cell: StaticBody2D = get_child(y * width + x)
	cell.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
	cell.visible = enabled
