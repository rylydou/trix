extends Node

signal paused()
signal resumed()
signal restarted()


@export var sensitivity := 0.0
var sensitivity_multiplier := 1.0

@export var bounds := Vector2(1280/2, 720/2)


@onready var transition_anim: AnimationPlayer = %'Transition Animation'
@onready var transition_control: Control = %'Transition Fade'

@onready var pause_anim: AnimationPlayer = %'Pause Animation'
@onready var win_anim: AnimationPlayer = %'Win Animation'

@onready var next_button: Button = %'Next Button'
@onready var hub_button: Button = %'Hub Button'
@onready var hub_button_alt: Button = %'Hub Button Alt'

@onready var sensitivity_slider: Slider = %'Sensitivity Slider'
@onready var sensitivity_label: Label = %'Sensitivity Label'


var mouse_delta: Vector2

var world: WorldData = null
var level: LevelData = null
var level_index := -1
var level_accumulated_ticks := 0
var level_ticks_to_skip := 0
var level_skip_ratio := 0.0

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
		restart_level()
		return
	
	if get_tree().paused: return
	
	if Input.is_action_just_pressed('pause'):
			pause()
			return
	
	if Input.is_action_just_pressed('cheat_skip'):
		Game.level_skip_ratio = 1.0


func _input(event: InputEvent) -> void:
	if get_tree().paused: return
	
	var mouse_motion_event = event as InputEventMouseMotion
	if mouse_motion_event:
		mouse_delta += mouse_motion_event.relative * sensitivity_multiplier


func pause() -> void:
	paused.emit()
	
	get_tree().paused = true
	release_mouse()
	pause_anim.play('show')

func resume() -> void:
	resumed.emit()
	
	capture_mouse()
	get_tree().paused = false
	pause_anim.play('hide')
	win_anim.play('hide')


func capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


var next_scene := ''
## Pass null to reload the current scene
var is_transitioning := false
func goto_scene(scene := '', color := Color.from_ok_hsl(0, 0, 1)) -> void:
	if is_transitioning: return
	is_transitioning = true
	
	get_tree().paused = true
	next_scene = scene
	transition_anim.animation_finished.connect(func(anim_name: StringName): _finish_goto_scene(), Node.CONNECT_ONE_SHOT)
	transition_control.modulate = color
	transition_anim.play('fade_in')


func _finish_goto_scene() -> void:
	if not is_transitioning: return
	
	Particles.restart_all()
	
	if next_scene.is_empty():
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file(next_scene)
	
	await get_tree().physics_frame
	
	level_ticks_to_skip = 0
	if get_tree().current_scene is Level:
		level_ticks_to_skip = get_tree().current_scene.ticks_to_skip
	
	is_transitioning = false
	transition_anim.play('fade_out')
	resume()


func win() -> void:
	get_tree().paused = true
	release_mouse()
	
	var show_next := is_instance_valid(world) and level_index < world.levels.size() - 1
	next_button.visible = show_next
	hub_button_alt.visible = not show_next
	hub_button.visible = show_next
	
	win_anim.play('show')


func fail_death(color := Color.from_ok_hsl(0, 0, .5)) -> void:
	restart_level(color)


func fail_out_of_time() -> void:
	restart_level(Color.from_ok_hsl(.17 / 360, 1, .57))


func restart_level(color := Color.from_ok_hsl(0, 0, 1)) -> void:
	restarted.emit()
	
	if get_tree().current_scene is Level:
		level_accumulated_ticks += get_tree().current_scene.tick
		level_skip_ratio = float(level_accumulated_ticks) / level_ticks_to_skip
	
	goto_scene('', color)


func back_to_hub() -> void:
	goto_scene('res://scenes/hub.tscn')


func set_level(level: LevelData) -> void:
	self.level = level
	level_accumulated_ticks = 0
	level_ticks_to_skip = 0
	level_skip_ratio = 0.0
	goto_scene(level.path, Color.WHITE)


func next_level() -> void:
	if not is_instance_valid(world): return
	if not is_instance_valid(level): return
	if level_index < 0: return
	
	if level_index >= world.levels.size() - 1:
		print('Cannot go to last level. This is the last level.')
		return
	
	level_index += 1
	level = world.levels[level_index]
	set_level(level)


func skip_level() -> void:
	if not get_tree().current_scene is Level: return
	if level_accumulated_ticks < get_tree().current_scene.ticks_to_skip: return
	level_accumulated_ticks = -1
	
	next_level()


func quit() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


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
