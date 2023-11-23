class_name Warn extends MeshInstance2D


@export var rotation_speed := 1.0


var node: Node2D
var ticks := 60


var tick := 0


func _ready() -> void:
	modulate = Calc.get_color(node.shield_hp)


func _physics_process(delta: float) -> void:
	tick += 1
	
	if tick > ticks:
		node.position = position
		get_parent().add_child(node)
		queue_free()
		return


func _process(delta: float) -> void:
	rotation += rotation_speed * TAU * delta
