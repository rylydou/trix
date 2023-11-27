extends Enemy


@export var pillar_scenes: Array[PackedScene]
@export var num_of_pillars: int
var pillars_left: int
var pillars_destroyed: bool

@export var bounds: Vector2

func _ready():
	pillars_destroyed = false
	pillars_left = num_of_pillars
	spawn_pillar()
	
func spawn_pillar():
	var pillar = pillar_scenes[num_of_pillars - pillars_left].instantiate()
	pillar.global_position = Vector2(randf_range(-bounds.x, bounds.x), randf_range(-bounds.y, bounds.y))
	pillar.destroy.connect(_on_pillar_break)
	get_tree().current_scene.add_child(pillar)
	
func _on_pillar_break():
	pillars_left -= 1
	if pillars_left <= 0:
		pillars_destroyed = true
	else:
		spawn_pillar()
	
func take_damage(damage:int, knockback:Vector2):
	if pillars_destroyed:
		return super.take_damage(damage, knockback)
	return true
