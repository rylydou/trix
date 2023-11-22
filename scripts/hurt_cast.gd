extends ShapeCast2D

@export var is_active := true

var player: Player

func _ready() -> void:
	player = owner
	top_level = true


func _physics_process(delta: float) -> void:
	if not is_active: return
	
	position = player.global_position - player.motion
	target_position = Vector2.ZERO
	
	for collision in collision_result:
		var collider = collision.collider
		if not collider: continue
		
		var is_dangerous := true
		var reported = collider.get('is_dangerous')
		if reported != null:
			is_dangerous = reported
		
		if is_dangerous:
			Game.restart()
