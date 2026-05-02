extends Control

@onready var level1_button = $Panel/VBoxContainer/level_button/HBoxContainer/level1_button/level1
@onready var level2_button = $Panel/VBoxContainer/level_button/HBoxContainer/level2_button/level2
@onready var level3_button = $Panel/VBoxContainer/level_button/HBoxContainer/level3_button/level3
@onready var back = $Panel/VBoxContainer/back_button/MarginContainer/Back

var pizza_success = load("res://images/active_pizza.png")
var pizza_unsuccess = load("res://images/inactive_pizza.png")

func _ready() -> void:
	SceneManager.current_scene_path = "res://scenes/chose_level_menu.tscn"
	
	level1_button.pressed.connect(_on_level1_button_pressed)
	level2_button.pressed.connect(_on_level2_button_pressed)
	level3_button.pressed.connect(_on_level3_button_pressed)
	back.pressed.connect(_on_back_button_pressed)
	
	_update_level_pizzas()


func _update_level_pizzas() -> void:
	for level_id in range(1, 4): #Від 1 до 3, тобто треб буде вводити кількість при додаванні рівнів
		var quality = _get_level_quality(level_id)
		_set_level_pizzas(level_id, quality)


func _get_level_quality(level_id: int) -> int:
	DataBaseManager.database.query("""
		SELECT quality
		FROM saving
		WHERE level_id = %d AND save_id = %d;
	""" % [level_id, DataBaseManager.curent_save])
	
	var result = DataBaseManager.database.query_result
	
	if result.is_empty():
		return 0
	
	return int(result[0]["quality"])


func _set_level_pizzas(level_id: int, quality: int) -> void:
	for pizza in get_tree().get_nodes_in_group("pizza"):
		var pizza_name := str(pizza.name)
		
		if not pizza_name.begins_with("pizza%d_" % level_id):
			continue
		
		var parts := pizza_name.split("_")
		var pizza_number := int(parts[1])
		
		if pizza_number <= quality:
			pizza.texture = pizza_success
		else:
			pizza.texture = pizza_unsuccess


func _on_level1_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_1.tscn")
	SceneManager.current_scene_path = "res://scenes/level_1.tscn"
	AudioManager.music_play()


func _on_level2_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_2.tscn")
	SceneManager.current_scene_path = "res://scenes/level_.tscn"
	AudioManager.music_play()


func _on_level3_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_3.tscn")
	SceneManager.current_scene_path = "res://scenes/level_.tscn"
	AudioManager.music_play()


func _on_back_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/main_menu.tscn"
	AudioManager.music_play()
