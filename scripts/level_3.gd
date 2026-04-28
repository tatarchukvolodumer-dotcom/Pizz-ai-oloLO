extends Node2D
@onready var Player = $Player
@onready var Bottom = $Bottom
@onready var Fork = load("res://scenes/fork.tscn")
@onready var Knife_r = load("res://scenes/knife_rotation.tscn")
@onready var Knife_h = load("res://scenes/knife_horizontal.tscn")
@onready var oven = $oven/Area2D
@onready var oven_animation = $oven/AnimatedSprite2D
@onready var timer = $Player/CanvasLayer/Timer_scene
@onready var secret = $secret/Area2D
@onready var secret_texture = $secret/TextureRect

@onready var Cam = $Player/Camera2D

var fork_positions = [
	Vector2(1600, 1110), #Y-1
	Vector2(1125, 630),
	Vector2(650, 1110) #Y-1
]

var knife_r_position = [
	Vector2(2000, 1060),
	Vector2(3000, 980)
]

var knife_h_position = [
	Vector2(1900, 300),
	Vector2(1100, 300),
	Vector2(1300, 400) #X-1
]

# Called when the node enters the scene tree for the first time.
# Початкова позиція плеєра (її можна встановити в будь-яку точку на рівні)
var spawn_position = Vector2(450, 900)  # Наприклад, (100, 100) — початкова точка

func _ready():
	SceneManager.level3_success = 0
	SceneManager.level3_success +=1
	secret_texture.texture = load("res://images/pizza_3.png")
	SceneManager.current_scene_path = "res://scenes/level_3.tscn"
	
	for pos in fork_positions:
		var instance = Fork.instantiate()
		instance.position = pos
		if instance.position.y > 630:
			instance.scale.y = -1
		var area = instance.get_node("AnimatableFork/Area2D")
		area.body_entered.connect(_on_fork_entered)
		add_child(instance)
	
	for pos in knife_h_position:
		var instance = Knife_h.instantiate()
		instance.position = pos
		if instance.position.y == 400:
			instance.scale.x = -1
		var area = instance.get_node("AnimatableBody2D/Area2D")
		area.body_entered.connect(_on_knife_horizontal_entered)
		add_child(instance)
	
	for pos in knife_r_position:
		var instance = Knife_r.instantiate()
		instance.position = pos
		add_child(instance)
	
	Bottom.body_entered.connect(Callable(self, "_on_bottom_entered"))# Сигнал спрацьовує, коли плеєр входить в телепортаційну зону
	oven.body_entered.connect(Callable(self, "_on_oven_entered"))
	secret.body_entered.connect(Callable(self, "_on_secret_entered"))
	
	Cam.limit_left = 178
	Cam.limit_top = 5
	Cam.limit_right = 3420
	Cam.limit_bottom = 1175
	
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
		SceneManager.level3_success += 1
		print(SceneManager.level3_success)

func _on_oven_entered(body):
	if body.name == "Player":
		AudioManager.sfx2_play("win")
		if timer.minutes != 0 or timer.seconds !=0:
			SceneManager.level3_success +=1
		print(SceneManager.level3_success)
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
		secret_texture.texture = load("res://images/pizza_3.png")
		SceneManager.level3_success = 1
