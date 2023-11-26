extends Group


func _ready() -> void:
	get_parent().shield_broken.connect(trigger)
