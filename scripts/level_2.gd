extends "res://scripts/level.gd"

func _set_for_son():
	timer.set_time(2, 0)
	Player._set_cam(144, 16, 2143, 855,)
	spawn_position = Vector2(293, 461)
	level_number = 2
