extends StaticBody2D


@export var hp := 5


@onready var maze: MazeGen = %'Maze'


var x := 0
var y := 0

var last_x := 0
var last_y := 0


func _ready() -> void:
	goto_random_corner()


func take_cut(dir: Vector2) -> bool:
	Particles.emit_kill(global_position)
	
	hp -= 1
	if hp <= 0:
		queue_free()
		return true
	
	goto_random_corner()
	
	var opposite_x := last_x != x
	var opposite_y := last_y != y
	
	var maze_x := 0 # Maze shape
	var maze_y := randi_range(0, 3) # Maze difficulty
	var flip_x := randi() % 2 == 0
	var flip_y := randi() % 2 == 0
	
	if opposite_x and not opposite_y: # Horizontal
		maze_x = 0
		flip_y = y > 0
	if not opposite_x and opposite_y: # Vertical
		maze_x = 1
		flip_x = x > 0
	if opposite_x and opposite_y: # Diagonal
		maze_x = 2
		var flip := (x > 0 and y < 0) or (x < 0 and y > 0)
		flip_x = false
		flip_y = false
		if flip:
			if randi() % 2 == 0:
				flip_x = true
				flip_y = false
			else:
				flip_x = false
				flip_y = true
	
	maze.generate(maze_x, maze_y, flip_x, flip_y)
	
	return true


func goto_random_corner() -> void:
	last_x = x
	last_y = y
	
	while x == last_x and y == last_y:
		x = -1 if randi() % 2 == 0 else 1
		y = -1 if randi() % 2 == 0 else 1
	
	position.x = x * (Game.bounds.x / 8 * 5.5)
	position.y = y * (Game.bounds.y / (4.5) * 2)
