extends Control


@onready var button: Button = %'Skip Button'
@onready var fill_material: ShaderMaterial = %'Skip Fill'.material
@onready var percent_label: Label = %'Skip Percent'
@onready var animation: AnimationPlayer = %'Skip Animation'


var forced_shown := false
var show_time := 0.0

var was_open := false


func _ready() -> void:
	Game.restarted.connect(scripted_open)


func _process(delta: float) -> void:
	visible = show_time > 0 or get_tree().current_scene is Level
	
	var ratio := clampf(Game.level_skip_ratio, 0.0, 1.0)
	fill_material.set_shader_parameter('radial_fill', ratio)
	percent_label.text = '%.f%%' % [ratio * 100]
	button.disabled = ratio < 1
	
	show_time -= delta
	
	var is_open: bool = show_time > 0 or %'Pause Menu'.visible
	
	if is_open and not was_open:
		animation.play('show')
	elif not is_open and was_open:
		animation.play('hide')
	
	was_open = is_open


var scripted_open_tween: Tween
func scripted_open() -> void:
	show_time = 1.0
