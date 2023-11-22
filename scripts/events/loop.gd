class_name Loop extends Group


@export var count := 10


func trigger() -> void:
	for index in range(count):
		await super.trigger()
