class_name BubbleButton extends Area2D


signal triggered()


@export var index = 0


@onready var sprite: TextureRect = %'Sprite'
@onready var label: Label = %'Label'
@onready var fill: Node2D = %'Fill'


var is_active := false
var has_player := false


func _init() -> void:
	body_entered.connect(
		func(body: Node2D):
			if body is Player:
				has_player = true
	)
	
	body_exited.connect(
		func(body: Node2D):
			if body is Player:
				has_player = false
	)


func _ready() -> void:
	var t := create_tween()
	scale = Vector2.ZERO
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	t.tween_property(self, 'scale', Vector2.ONE, 1.0).set_delay(index * .2)
	t.parallel().tween_callback(func(): is_active = true).set_delay(.1)


func _process(delta: float) -> void:
	if not is_active: return
	
	if has_player and Input.is_action_just_pressed('shoot'):
		triggered.emit()
		trigger()


func trigger() -> void:
	pass
