extends Node2D

@onready var music = $music
@onready var sfx1 = $sfx1
@onready var sfx2 = $sfx2

var level_music = preload("res://sound/music/level.ogg")
var menu_music = preload("res://sound/music/main_menu.ogg")

func _ready():
	music_play()

func music_play() -> void:
	var new_stream: AudioStream

	if SceneManager.current_scene_path in [
		"res://scenes/level_1.tscn",
		"res://scenes/level_2.tscn",
		"res://scenes/level_3.tscn"
	]:
		new_stream = level_music
	else:
		new_stream = menu_music
		
	if music.stream != new_stream:
		music.stream = new_stream
		music.play()
	elif not music.playing:
		music.play()

func sfx1_play(effect: String) -> void:
	if effect == "jump":
		sfx1.stream = preload("res://sound/effects/jump_1.wav")
	elif effect == "jump2":
		sfx1.stream = preload("res://sound/effects/jump_2.wav")
	elif effect == "hit":
		sfx1.stream = load("res://sound/effects/hit_1.wav")
	elif effect == "death":
		sfx1.stream = load("res://sound/effects/death.wav")
	sfx1.play()

func sfx2_play(effect: String) -> void:
	if effect == "win":
		sfx2.stream = load("res://sound/effects/win.wav")
	elif effect == "secret":
		sfx2.stream = load("res://sound/effects/secret.wav")
	sfx2.play()
