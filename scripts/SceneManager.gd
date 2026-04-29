extends Node

var previous_scene_path: String = ""
var current_scene_path: String = "res://scenes/main_menu.tscn"

var levels_success = {
	1: 0,
	2: 0,
	3: 0
}

func set_level_success(level_number: int, value: int) -> void:
	if !levels_success.has(level_number):
		levels_success[level_number] = 0

	levels_success[level_number] = clamp(value, 0, 3)

func get_level_success(level_number: int) -> int:
	return levels_success.get(level_number, 0)

func get_level_number_from_path(path: String) -> int:
	match path:
		"res://scenes/level_1.tscn":
			return 1
		"res://scenes/level_2.tscn":
			return 2
		"res://scenes/level_3.tscn":
			return 3
		_:
			return 0

func get_next_level_path(path: String) -> String:
	match path:
		"res://scenes/level_1.tscn":
			return "res://scenes/level_2.tscn"
		"res://scenes/level_2.tscn":
			return "res://scenes/level_3.tscn"
		_:
			return ""
