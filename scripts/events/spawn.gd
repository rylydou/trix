class_name Spawn extends Marker2D


@export var required_for_completion := true

@export var spawn_node: Node2D
@export var spawn_scene: PackedScene
@export var spawn_target: Node2D


func _ready() -> void:
	if not spawn_target:
		spawn_target = owner
	
	if spawn_node:
		spawn_scene = PackedScene.new()
		spawn_node.queue_free()
		var err := spawn_scene.pack(spawn_node)
		
		assert(err == OK, error_string(err))
	
	assert(spawn_scene, 'No scene or node was set to spawn.')


func trigger() -> void:
	var node: Node2D = spawn_scene.instantiate()
	
	if node.has_method('get_init_position'):
		var init_position: Vector2 = node.call('get_init_position', spawn_target)
		node.position = init_position
	else:
		var offset := Vector2(randf_range(-gizmo_extents, gizmo_extents), randf_range(-gizmo_extents, gizmo_extents))
		node.position = global_position + offset
	
	var t := create_tween()
	t.tween_callback(func(): spawn_target.add_child(node)).set_delay(1.0)
	Particles.emit_warn(node.global_position)
