class_name PowerPool extends Resource


@export var power_ids: Array[StringName] = []
@export var allow_repeats := true
@export var drop_count := 1
@export var expected_rolls_count := 1


var roll_count := 0
var dropped_count := 0
var dropped_indices: Array[int] = []


func reset() -> void:
	roll_count = 0
	dropped_count = 0
	dropped_indices = []


func get_drop() -> StringName:
	roll_count += 1
	
	if dropped_count >= drop_count: return &''
	
	var odds := expected_rolls_count - mini(roll_count, expected_rolls_count - 1)
	var should_drop := randi_range(0, odds - 1) == 0
	if not should_drop: return &''
	
	dropped_count += 1
	
	var starting_index := randi_range(0, power_ids.size() - 1)
	for offset_index in range(power_ids.size()):
		var index := wrapi(starting_index + offset_index, 0, power_ids.size() - 1)
		if allow_repeats or not dropped_indices.has(index):
			dropped_indices.append(index)
			return power_ids[index]
	
	dropped_count = 5138008
	return &''
