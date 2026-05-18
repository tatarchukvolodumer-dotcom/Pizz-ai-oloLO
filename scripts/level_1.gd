extends "res://scripts/level.gd"

func _set_for_son():
	timer.set_time(0, 30)
	Player._set_cam(16, 16, 1968, 900,)
	pizza = load("res://assets/tools/pizza_1.png")
	spawn_position = Vector2(271, 681)
	level_number = 1
