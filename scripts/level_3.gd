extends "res://scripts/level.gd"

func _set_for_son():
	timer.set_time(5, 0)
	Player._set_cam(16, 16, 3264, 1344,)
	pizza = load("res://images/pizza_3.png")
	spawn_position = Vector2(192, 885)
	level_number = 3
