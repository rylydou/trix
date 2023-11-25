extends Button


func _ready() -> void:
	pressed.connect(toggle_fullscreen)
	toggle_fullscreen()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('fullscreen', true):
		toggle_fullscreen()


func toggle_fullscreen() -> void:
	var window := get_window()
	if get_window().mode == Window.MODE_WINDOWED:
		text = 'Go Windowed'
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		text = 'Go Fullscreen'
		get_window().mode = Window.MODE_WINDOWED
		window.size.x = ProjectSettings.get_setting_with_override('display/window/size/window_width_override')
		window.size.y = ProjectSettings.get_setting_with_override('display/window/size/window_height_override')
		for i in range(4): # It might take the system a few frames to actually change the window mode
			await get_tree().process_frame
			window.move_to_center()
