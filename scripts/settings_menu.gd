extends Node

#buttons
@onready var apply = $Panel/VBoxContainer/MarginContainer3/HBoxContainer/MarginContainer/apply_button
@onready var default = $Panel/VBoxContainer/MarginContainer3/HBoxContainer/MarginContainer2/default_button
@onready var back = $Panel/VBoxContainer/MarginContainer3/HBoxContainer/MarginContainer3/back_button3

#widgets
@onready var master_volume = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/values/VBoxContainer/v_master_volume/master_volume_slider
@onready var music_volume = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/values/VBoxContainer/v_music_volume/music_volume_slider
@onready var sfx_volume = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/values/VBoxContainer/v_SFX_volume/SFX_volume_slider
@onready var screen_resolution = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/values/VBoxContainer/v_screen_resolution/screen_resolution
@onready var display_mode = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/values/VBoxContainer/v_display_mode/display_mode
@onready var brightness = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/values/VBoxContainer/v_brightness/brightness_slider
@onready var fps_lock = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/values/VBoxContainer/v_fps_lock/HBoxContainer/MarginContainer/fps_lock

var saved_settings = {}

func _ready() -> void:
	SceneManager.current_scene_path = "res://scenes/settings_menu.tscn"
	
	# Запам'ятовуємо стан налаштувань, який був збережений/завантажений
	# на момент входу в меню.
	saved_settings = SettingsManager.game_data.duplicate(true)
	
	apply.pressed.connect(_on_apply_pressed)
	default.pressed.connect(_on_default_pressed)
	back.pressed.connect(_on_back_pressed)
	
	# Заповнюємо елементи меню поточними значеннями з SettingsManager.
	setup_widgets_from_current_settings()

	# Підключаємо сигнали після початкового заповнення,
	# щоб при старті меню не виникали зайві виклики.
	connect_widget_signals()

func setup_widgets_from_current_settings() -> void:	
	# Master Volume
	master_volume.min_value = -40
	master_volume.max_value = 0
	master_volume.value = SettingsManager.game_data["master_vol"]
	master_volume.update_visuals()

	# Music Volume
	music_volume.min_value = -40
	music_volume.max_value = 0
	music_volume.value = SettingsManager.game_data["music_vol"]
	music_volume.update_visuals()
	
	# SFX Volume
	sfx_volume.min_value = -40
	sfx_volume.max_value = 0
	sfx_volume.value = SettingsManager.game_data["sfx_vol"]
	sfx_volume.update_visuals()
	
	#Brightness
	brightness.min_value = 0.5
	brightness.max_value = 1.5
	brightness.value = SettingsManager.game_data["brightness"]
	brightness.update_visuals()
	
	# Screen Resolution
	var saved_res = SettingsManager.game_data["screen_resolution"]
	
	for i in range(screen_resolution.options.size()):
		if screen_resolution.options[i] == saved_res:
			screen_resolution.current_index = i
			break

	screen_resolution.update_label()
	
	# Display Mode
	var saved_mode = SettingsManager.game_data["display_mode"]
	for i in range(display_mode.options.size()):
		if display_mode.options[i]["value"] == saved_mode:
			display_mode.current_index = i
			break
	display_mode.update_label()
	
	# FPS Lock
	var saved_fps = SettingsManager.game_data["max_fps"]

	for i in range(fps_lock.options.size()):
		if int(fps_lock.options[i]) == saved_fps:
			fps_lock.current_index = i
			break

	fps_lock.update_label()

# Підключає сигнали віджетів до обробників.
# Винесено в окрему функцію для чистоти коду.
func connect_widget_signals() -> void:
	master_volume.value_changed.connect(_on_master_volume_slider_changed)
	music_volume.value_changed.connect(_on_music_volume_slider_changed)
	sfx_volume.value_changed.connect(_on_sfx_volume_slider_changed)
	brightness.value_changed.connect(_on_brightness_slider_changed)

	screen_resolution.resolution_changed.connect(_on_resolution_changed)
	display_mode.mode_changed.connect(_on_display_mode_changed)
	fps_lock.fps_changed.connect(_on_fps_changed)

func apply_current_settings() -> void:
	SettingsManager.apply_all_settings()

func _on_apply_pressed() -> void:
	SettingsManager.save_data()
	saved_settings = SettingsManager.game_data.duplicate(true)
	
func _on_default_pressed() -> void:
	SettingsManager.reset_to_defaults()
	setup_widgets_from_current_settings()
	apply_current_settings()
	
func _on_back_pressed() -> void:
	SettingsManager.game_data = saved_settings.duplicate(true)
	apply_current_settings()

	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/main_menu.tscn"
	AudioManager.music_play()
	
func _on_brightness_slider_changed(new_value) -> void:
	SettingsManager.game_data["brightness"] = new_value
	SettingsManager.apply_brightness()

func _on_master_volume_slider_changed(new_value) -> void:
	SettingsManager.game_data["master_vol"] = new_value
	SettingsManager.apply_master_volume()

func _on_music_volume_slider_changed(new_value) -> void:
	SettingsManager.game_data["music_vol"] = new_value
	SettingsManager.apply_music_volume()
	
func _on_sfx_volume_slider_changed(new_value) -> void:
	SettingsManager.game_data["sfx_vol"] = new_value
	SettingsManager.apply_sfx_volume()
	
func _on_resolution_changed(new_resolution: Vector2i) -> void:
	SettingsManager.game_data["screen_resolution"] = new_resolution
	SettingsManager.apply_resolution()
	
func _on_display_mode_changed(new_mode: String) -> void:
	SettingsManager.game_data["display_mode"] = new_mode
	SettingsManager.apply_display_mode()
	if new_mode == "windowed":
		SettingsManager.apply_resolution()
	
func _on_fps_changed(new_fps: int) -> void:
	SettingsManager.game_data["max_fps"] = new_fps
	SettingsManager.apply_video_settings()
