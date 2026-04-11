extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D=$AnimatedSprite2D

#Константи руху
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#Напрямок
var direction
#Індикатор анімації початку стрибку
var jump_start = false
#Індикатор польоту
var jump_in = false
#Індикатор подвійного стрибку
var jump_double = true

#Базована функція
func _physics_process(delta: float) -> void:
	# Гравітація
	if not is_on_floor():
		velocity += get_gravity() * delta
		if jump_start:
			return
		else:
			animated_sprite_2d.play("jump_in")
	
	if is_on_floor():
		if jump_in:
			animated_sprite_2d.play("jump_end")
		elif direction:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	# Стрибок
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_double):
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jump_start")
		jump_start = true
		if not is_on_floor():
			jump_double = false
	
	#Рух туди і сюди
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#А чорт його зна
	move_and_slide()
	
	#Поворт тудим і сюдим
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	if direction == -1.0:
		animated_sprite_2d.flip_h = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "jump_start":
		jump_in = true
		jump_start = false
	
	if animated_sprite_2d.animation == "jump_end":
		jump_in = false
		jump_double = true
