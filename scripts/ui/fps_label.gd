extends Label


func _enter_tree() -> void:
	if OS.is_debug_build():
		show()
	else:
		hide()


func _process(delta: float) -> void:
	var fps := Performance.get_monitor(Performance.TIME_FPS)
	text = '%s fps' % [fps]
