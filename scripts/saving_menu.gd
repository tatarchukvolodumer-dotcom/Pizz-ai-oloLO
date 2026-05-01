extends Control
@onready var savinq1 = $Panel/VBoxContainer/MarginContainer2/saving1
@onready var savinq2 = $Panel/VBoxContainer/MarginContainer3/saving2
@onready var savinq3 = $Panel/VBoxContainer/MarginContainer4/saving3
@onready var back = $Panel/VBoxContainer/MarginContainer5/Back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.current_scene_path = "res://scenes/saving_menu.tscn"
	savinq1.pressed.connect(_on_saving1_pressed)
	savinq2.pressed.connect(_on_saving2_pressed)
	savinq3.pressed.connect(_on_saving3_pressed)
	back.pressed.connect(_on_back_pressed)

func _on_saving1_pressed() -> void:
	DataBaseManager.curent_save = 1
	_saving()
	
func _on_saving2_pressed() -> void:
	DataBaseManager.curent_save = 2
	_saving()
	
func _on_saving3_pressed() -> void:
	DataBaseManager.curent_save = 3
	_saving()
	
func _on_back_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/main_menu.tscn"
	AudioManager.music_play()

func _saving() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/chose_level_menu.tscn") 
	SceneManager.current_scene_path = "res://scenes/chose_level_menu.tscn"
	AudioManager.music_play()
