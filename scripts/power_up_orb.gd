extends Area2D


@export var power_up_id := ''


@onready var power_up: PowerUp = Consts.powers_ups[power_up_id].new()


func _ready() -> void:
	$'Label'.text = power_up.get_name()[0]


func _on_body_entered(player: Player) -> void:
	player.set_power_up(power_up)
	Particles.emit_kill(global_position)
	queue_free()
