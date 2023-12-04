class_name Warn extends Delay



@export var circle_scale := 1.0


var scene: PackedScene = preload('res://scenes/warn_alt.tscn')
var circle: Node2D
var tween: Tween


func _ready() -> void:
	circle = scene.instantiate()
	add_child(circle)
	circle.modulate.a = 0


func trigger() -> void:
	# Particles.emit_warn(global_position)
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(circle, 'scale', Vector2.ONE * circle_scale, ticks / 60.).from(Vector2.ZERO)
	tween.parallel().tween_property(circle, 'modulate:a', 1.0, ticks / 60.).from(0.0)
	tween.tween_property(circle, 'scale', Vector2.ZERO, ticks / 60. /2)
	tween.parallel().tween_property(circle, 'modulate:a', 0.0, ticks / 60. /2)
	
	await super.trigger()


func _physics_process(delta: float) -> void:
	circle.position = global_position
