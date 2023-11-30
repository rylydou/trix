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
		btn.set_meta('world', world)
		btn.triggered.connect(func():
			Game.world = world
			Game.level = null
			Game.level_index = -1
			update()
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
		child.fill.visible = child.get_meta('world') == Game.world
	
	if not Game.world: return
	
	var index = 0
	for level in Game.world.levels:
		var btn: BubbleButton = button_scene.instantiate()
		btn.index = index
		btn.position = get_button_placement(index, Game.world.levels.size())
		btn.triggered.connect(func():
			Game.level_index = index
			Game.set_level(level)
		)
		level_buttons.add_child(btn)
		if level.is_boss:
			btn.sprite.texture = preload('res://content/sprites/skull.svg')
		else:
			btn.label.text = str(index + 1)
		
		btn.hint.text = level.name
		
		if index == Game.level_index:
			$'Player'.global_position = btn.global_position
		
		index += 1


func get_button_placement(index: int, count: int) -> Vector2:
	return Vector2(
		(index - float(count - 1) / 2) * 96,
		0.0 if count == 1 else (64 * Calc.as_sign(index % 2 == 1))
	)
