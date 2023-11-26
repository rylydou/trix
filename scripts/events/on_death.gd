extends Group

func _ready() -> void:
	get_parent().killed.connect(trigger)
