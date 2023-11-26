class_name Spawn extends Marker2D


enum SpawnRotation {
	Unset,
	Inherit,
	Randomize,
	TowardPlayer,
}

enum SpawnColor {
	Unset,
	Inherit,
	Randomize,
}


@export var scene: PackedScene
@export var target_parent: Node2D

@export var warn_ticks := 30
@export var spawn_rotation := SpawnRotation.Randomize
@export var health_override := -1
@export var spawn_color := SpawnColor.Unset


func _ready() -> void:
	if not target_parent:
		target_parent = get_tree().current_scene
	
	assert(scene, 'No scene or node was set to spawn.')


func trigger() -> void:
	var offset := Vector2(randf_range(-gizmo_extents, gizmo_extents), randf_range(-gizmo_extents, gizmo_extents))
	var target_position = global_position + offset
	
	var node = scene.instantiate()
	node.global_position = target_position
	set_node_rotation(node)
	set_node_color(node)
	
	if health_override > 0:
		node.shield_hp = health_override
	
	if warn_ticks <= 0:
		target_parent.add_child(node)
		return
	
	var warn_node: Warn = Consts.scn_warn.instantiate()
	warn_node.node = node
	warn_node.ticks = warn_ticks
	node.global_position = target_position
	
	target_parent.add_child(warn_node)
	warn_node.global_position = target_position


func set_node_rotation(node: Node2D) -> void:
	match spawn_rotation:
		SpawnRotation.Unset: return
		
		SpawnRotation.Inherit:
			node.global_rotation = global_rotation
		
		SpawnRotation.Randomize:
			node.rotation = randf_range(0, 2*PI)
		
		SpawnRotation.TowardPlayer:
			if not is_instance_valid(Player.current):
				node.rotation = randf_range(0, 2*PI)
				return
			
			node.rotation = node.global_position.angle_to_point(Player.current.global_position)


func set_node_color(node: Node2D) -> void:
	match spawn_color:
		SpawnColor.Unset: return
		
		SpawnColor.Inherit:
			node.modulate = modulate
		
		SpawnColor.Randomize:
			node.modulate = Calc.get_color(randi())
