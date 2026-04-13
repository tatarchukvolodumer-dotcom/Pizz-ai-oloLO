extends Node2D
@onready var Player = $Player
@onready var Bottom = $Bottom
@onready var Fork = load("res://scenes/fork.tscn")
@onready var Knife_r = load("res://scenes/knife_rotation.tscn")
@onready var Knife_horizontal = $knife_horizontal/AnimatableBody2D/Area2D

@onready var Cam = $Player/Camera2D

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
	
	Cam.limit_left = 305
	Cam.limit_top = 405
	Cam.limit_right = 2300
	Cam.limit_bottom = 1250
	
	
func _on_bottom_entered(body):
	_death(body)
		
func _on_fork_entered(body):
	_death(body)
		
func _on_knife_horizontal_entered(body):
	_death(body)
		
func _death(body):
	# Перевіряємо, чи це плеєр
	if body == Player and !Player.invinceble:  # Перевіряємо, чи цей об'єкт — плеєр
		# Відновлюємо плеєра на початкову позицію
		body.position = spawn_position
