class_name Consts extends RefCounted


# ----- Scenes -----
# static var scn_hub := preload('res://scenes/hub.tscn')
static var scn_warn := preload('res://scenes/warn.tscn')
static var scn_power_up_label := preload('res://scenes/power_up_label.tscn')


# ----- Scripts -----
static var power_up_base = preload('res://scripts/power_ups/basic.gd')
static var powers_ups = {
	&'basic': preload('res://scripts/power_ups/basic.gd'),
	&'mega': preload('res://scripts/power_ups/mega.gd'),
}
