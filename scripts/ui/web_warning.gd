extends Control


func _ready() -> void:
	if not OS.has_feature('web'):
		hide()
		return
	
	for i in range(10):
		get_tree().paused = true
		Game.release_mouse()
		await get_tree().process_frame


func ok() -> void:
	hide()
	get_tree().paused = false
	Game.capture_mouse()
	Game.resume()
	
	%'Quit Button'.hide()
