extends Node2D
@onready var Player = $Player
@onready var Bottom = $Bottom
@onready var Fork = load("res://scenes/fork.tscn")
@onready var Knife_r = load("res://scenes/knife_rotation.tscn")
@onready var Knife_horizontal = $knife_horizontal/AnimatableBody2D/Area2D
@onready var Oven_area = $oven/Area2D
@onready var oven_animation = $oven/AnimatedSprite2D

@onready var Cam = $Player/Camera2D

@onready var timer = $Player/CanvasLayer/Timer_scene
@onready var secret = $secret/Area2D
@onready var secret_texture = $secret/TextureRect

var fork_positions = [
	Vector2(876, 1120),
	Vector2(608, 1120),
	Vector2(1200, 450),
	Vector2(1400, 500),
	Vector2(1600, 600),
	Vector2(1120, 1100)
]

var knife_r_position = [
	Vector2(800, 750),
	Vector2(1060, 750)
]

# Called when the node enters the scene tree for the first time.
# Початкова позиція плеєра (її можна встановити в будь-яку точку на рівні)
var spawn_position = Vector2(450, 900)  # Наприклад, (100, 100) — початкова точка

func _ready():
	SceneManager.level2_success = 0
	SceneManager.level2_success +=1
	secret_texture.texture = load("res://images/pizza_2.png")
	SceneManager.current_scene_path = "res://scenes/level_2.tscn"
	
	for pos in fork_positions:
		var instance = Fork.instantiate()
		instance.position = pos
		if instance.position.y > 1101:
			instance.scale.y = -1
		var area = instance.get_node("AnimatableFork/Area2D")
		area.body_entered.connect(_on_fork_entered)
		add_child(instance)
	
	for pos in knife_r_position:
		var instance = Knife_r.instantiate()
		instance.position = pos
		add_child(instance)
	
	# Підключаємо сигнал body_entered від телепортаційної зони до методу
	Bottom.body_entered.connect(Callable(self, "_on_bottom_entered"))# Сигнал спрацьовує, коли плеєр входить в телепортаційну зону
	Knife_horizontal.body_entered.connect(Callable(self, "_on_knife_horizontal_entered"))
	Oven_area.body_entered.connect(Callable(self, "_on_oven_entered"))
	secret.body_entered.connect(Callable(self, "_on_secret_entered"))
	
	Cam.limit_left = 305
	Cam.limit_top = 405
	Cam.limit_right = 2300
	Cam.limit_bottom = 1250

func _process(delta):
	if timer.minutes == 0 and timer.seconds == 0:
		if oven_animation.animation != "unsuccess":
			oven_animation.play("unsuccess")
	else:
		if oven_animation.animation != "success":
			oven_animation.play("success")
	
func _on_secret_entered(body):
	if body.name == "Player" and secret_texture.texture != null:
		AudioManager.sfx2_play("secret")
		secret_texture.texture = null
		SceneManager.level2_success += 1
		print(SceneManager.level2_success)
	
func _on_oven_entered(body):
	if body.name == "Player":
		AudioManager.sfx2_play("win")
		if timer.minutes != 0 or timer.seconds !=0:
			SceneManager.level2_success +=1
		print(SceneManager.level2_success)
		SceneManager.previous_scene_path = SceneManager.current_scene_path
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level_finished_menu.tscn")
		SceneManager.current_scene_path = "res://scenes/level_finished_menu.tscn"
		AudioManager.music_play()
	
func _on_bottom_entered(body):
	_death(body)
		
func _on_fork_entered(body):
	_death(body)
		
func _on_knife_horizontal_entered(body):
	_death(body)
		
func _death(body):
	# Перевіряємо, чи це плеєр
	if body == Player and !Player.invinceble:  # Перевіряємо, чи цей об'єкт — плеєр
		AudioManager.sfx1_play("death")
		# Відновлюємо плеєра на початкову позицію
		body.position = spawn_position
		secret_texture.texture = load("res://images/pizza_2.png")
		SceneManager.level2_success = 1
