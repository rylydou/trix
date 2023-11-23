extends Node

@export var sensitivity := 0.0
var sensitivity_multiplier := 1.0

@export var bounds := Vector2(1280/2, 720/2)

@export var hub_scene: PackedScene


@export_group('Colors')
@export var bad_shield_color := Color.RED
@export var bad_vulnerable_color := Color.YELLOW


@onready var pause_menu: Control = %'Pause Menu'
@onready var sensitivity_slider: Slider = %'Sensitivity Slider'
@onready var sensitivity_label: Label = %'Sensitivity Label'


var mouse_delta: Vector2


func _ready() -> void:
	if OS.has_feature('web') or not OS.is_debug_build():
		pause()
	else:
		resume()
	
	sensitivity = PlayerPrefs.get_pref('sensitivity', sensitivity)
	sensitivity_slider.value = sensitivity
	
	if not OS.is_debug_build():
		get_window().focus_exited.connect(pause)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('restart'):
		restart()
		return
	
	if get_tree().paused: return
	
	if Input.is_action_just_pressed('pause'):
			pause()
			return


func _input(event: InputEvent) -> void:
	if get_tree().paused: return
	
	var mouse_motion_event = event as InputEventMouseMotion
	if mouse_motion_event:
		mouse_delta += mouse_motion_event.relative * sensitivity_multiplier


func pause() -> void:
	get_tree().paused = true
	release_mouse()
	pause_menu.show()

func resume() -> void:
	pause_menu.hide()
	capture_mouse()
	get_tree().paused = false


func capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func restart() -> void:
	get_tree().paused = true
	get_tree().reload_current_scene()
	await get_tree().process_frame
	Particles.restart_all()
	resume()

func _on_sensitivity_slider_value_changed(value: float) -> void:
	sensitivity = value
	
	sensitivity_multiplier = 1.0
	if value > 0:
		sensitivity_multiplier = 1 + value
	elif value < 0:
		sensitivity_multiplier = 1.0 - (abs(value) / 4.0)
	
	# sensitivity_label.text = '%+.1f' % [value]
	sensitivity_label.text = '%d%%' % [sensitivity_multiplier * 100]
	
	PlayerPrefs.set_pref('sensitivity', sensitivity)


func back() -> void:
	get_tree().change_scene_to_packed(hub_scene)
	await get_tree().process_frame
	Particles.restart_all()
	resume()

func quit() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
