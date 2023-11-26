@icon('res://content/icons/loop.svg')
class_name Loop extends Group


@export var count := -1


func trigger() -> void:
	if count <= 0:
		while true:
			await super.trigger()
	
	for index in range(count):
		await super.trigger()
