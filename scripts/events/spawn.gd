class_name Spawn extends Marker2D


@export var required_for_completion := true
@export var warn_ticks := 60

@export var target_parent: Node2D
@export var scene: PackedScene
@export var node: Node2D


func _ready() -> void:
	if not target_parent:
		target_parent = owner
	
	if node:
		scene = PackedScene.new()
		node.queue_free()
		var err := scene.pack(node)
		
		assert(err == OK, error_string(err))
	
	assert(scene, 'No scene or node was set to spawn.')


func trigger() -> void:
	var offset := Vector2(randf_range(-gizmo_extents, gizmo_extents), randf_range(-gizmo_extents, gizmo_extents))
	var target_position = global_position + offset
	
	
	var warn_node: Warn = Consts.scn_warn.instantiate()
	warn_node.node = scene.instantiate()
	warn_node.ticks = warn_ticks
	
	target_parent.add_child(warn_node)
	warn_node.global_position = target_position
