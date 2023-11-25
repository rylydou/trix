extends Enemy


# Called when the node enters the scene tree for the first time.
func _init():
	pass


func _shield_broken():
	super._death()
