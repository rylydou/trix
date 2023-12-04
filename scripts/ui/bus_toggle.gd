extends CheckButton


@export var bus := &''


func _ready() -> void:
	button_pressed = PlayerPrefs.get_pref(str('bus.',bus), true)
	update()
	
	pressed.connect(update)


func update() -> void:
	var index := AudioServer.get_bus_index(bus)
	AudioServer.set_bus_mute(index, not button_pressed)
	PlayerPrefs.set_pref(str('bus.',bus), button_pressed)
