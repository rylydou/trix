class_name Start extends Group


func _ready() -> void:
	await get_tree().physics_frame
	
	super.trigger()
