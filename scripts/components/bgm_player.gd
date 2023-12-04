extends AudioStreamPlayer


var low_pass := false


func _ready() -> void:
	Game.paused.connect(func(): low_pass = true)
	Game.resumed.connect(func(): low_pass = false)


func _process(delta: float) -> void:
	var bus_index := AudioServer.get_bus_index(&'BGM')
	AudioServer.set_bus_bypass_effects(bus_index, not low_pass)
