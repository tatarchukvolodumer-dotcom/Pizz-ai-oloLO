extends Control

@onready var Back = $Panel/Back_Button
@onready var Retry = $Panel/Retry_Button
@onready var Next = $Panel/Next_Button

@onready var success_1 = $Panel/HBoxContainer1/MarginContainer/pizza1
@onready var success_2 = $Panel/HBoxContainer1/MarginContainer2/pizza2
@onready var success_3 = $Panel/HBoxContainer1/MarginContainer3/pizza3

var pizza_success = load("res://images/pizza_success_finished_level.png")
var pizza_unsuccess = load("res://images/pizza_unsuccess_finished_level.png")

var level_number : int
var success_count : int

func _ready() -> void:
	SceneManager.current_scene_path = "res://scenes/level_finished_menu.tscn"
	
	_success_levels()
	
	_data_write()
	
	Back.pressed.connect(_on_back_button_pressed)
	Retry.pressed.connect(_on_retry_button_pressed)
	Next.pressed.connect(_on_next_button_pressed)

	if SceneManager.get_next_level_path(SceneManager.previous_scene_path) == "":
		Next.disabled = true

func _success_levels() -> void:
	success_1.texture = pizza_unsuccess
	success_2.texture = pizza_unsuccess
	success_3.texture = pizza_unsuccess

	level_number = SceneManager.get_level_number_from_path(SceneManager.previous_scene_path)
	success_count = SceneManager.get_level_success(level_number)

	if success_count >= 1:
		success_1.texture = pizza_success

	if success_count >= 2:
		success_2.texture = pizza_success

	if success_count >= 3:
		success_3.texture = pizza_success

func _on_back_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/chose_level_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/chose_level_menu.tscn"
	AudioManager.music_play()

func _on_retry_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", SceneManager.previous_scene_path)
	SceneManager.current_scene_path = SceneManager.previous_scene_path
	AudioManager.music_play()

func _on_next_button_pressed() -> void:
	var next_level_path = SceneManager.get_next_level_path(SceneManager.previous_scene_path)

	if next_level_path != "":
		get_tree().call_deferred("change_scene_to_file", next_level_path)
		SceneManager.current_scene_path = next_level_path
		AudioManager.music_play()

func _data_write():
	DataBaseManager.database.query("""
	SELECT *
	FROM saving
	WHERE level_id = %d
	and save_id = %d;
	""" % [level_number, DataBaseManager.curent_save])
	
	if DataBaseManager.database.query_result.is_empty():
		DataBaseManager.database.query("""INSERT into saving(level_id, save_id, quality) 
		VALUES (%d, %d, %d);
		""" % [level_number, DataBaseManager.curent_save, success_count])
	else:
		DataBaseManager.database.query("""
			UPDATE saving
			SET quality = %d
			WHERE level_id = %d and save_id = %d and quality < %d;
		""" % [success_count, level_number, DataBaseManager.curent_save, success_count])
