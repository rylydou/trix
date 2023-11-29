class_name Hub extends Node2D


@export var button_scene: PackedScene
@export var worlds: Array[WorldData] = []


@onready var world_buttons: Node2D = %'World Buttons'
@onready var level_buttons: Node2D = %'Level Buttons'



func _ready() -> void:
	var index = 0
	for world in worlds:
		var btn: BubbleButton = button_scene.instantiate()
		btn.position.x = (index - float(worlds.size() - 1) / 2) * (128 + 16)
		btn.index = index
		btn.triggered.connect(func():
			Game.current_world = world
			Game.current_level = null
			Game.current_level_index = -1
			update()
			btn.fill.show()
		)
		
		world_buttons.add_child(btn)
		btn.sprite.texture = world.sprite
		btn.hint.text = world.name
		
		index += 1
	
	update()


func update() -> void:
	for child in level_buttons.get_children():
		child.queue_free()
	
	for child in world_buttons.get_children():
		child.fill.hide()
	
	if not Game.current_world: return
	
	var index = 0
	for level in Game.current_world.levels:
		var btn: BubbleButton = button_scene.instantiate()
		btn.index = index
		btn.position = get_button_placement(index, Game.current_world.levels.size())
		btn.triggered.connect(func():
			Game.current_level = level
			Game.current_level_index = index
			Game.goto_scene(level.path)
		)
		level_buttons.add_child(btn)
		if level.is_boss:
			btn.sprite.texture = preload('res://content/sprites/skull.svg')
		else:
			btn.label.text = str(index + 1)
		
		btn.hint.text = level.name
		
		index += 1


func get_button_placement(index: int, count: int) -> Vector2:
	return Vector2(
		(index - float(count - 1) / 2) * 96,
		0.0 if count == 1 else (64 * Calc.as_sign(index % 2 == 1))
	)
