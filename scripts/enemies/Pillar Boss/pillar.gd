extends Enemy

signal destroy

@export var spawns: Array[Spawn]
@export var path_scene: PackedScene
var path: Path2D
func _ready():
	path = path_scene.instantiate()
	path.global_position = global_position
	
	get_tree().current_scene.add_child(path)
	for x in spawns:
		x.target_parent = path

func die():
	destroy.emit()
	path.queue_free()
	super.die()
