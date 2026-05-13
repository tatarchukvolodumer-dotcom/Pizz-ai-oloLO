extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var Cam: Camera2D = $Camera2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction := 0.0
var jump_start := false
var jump_in := false
var jump_double := true
var invincible := false


func _physics_process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	
	_fly(delta)
	_on_floor()
	_jump()
	_go()
	move_and_slide()
	_turn()
	_invincible()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "jump_start":
		jump_in = true
		jump_start = false
	
	if animated_sprite_2d.animation == "jump_end":
		jump_in = false
		jump_double = true


func _set_cam(left: int, top: int, right: int, bottom: int) -> void:
	Cam.limit_left = left
	Cam.limit_top = top
	Cam.limit_right = right
	Cam.limit_bottom = bottom


func _fly(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		if jump_start:
			return
		else:
			animated_sprite_2d.play("jump_in")
			jump_in = true


func _on_floor() -> void:
	if is_on_floor():
		if jump_in:
			animated_sprite_2d.play("jump_end")
			AudioManager.sfx1_play("hit")
		elif direction:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")


func _jump() -> void:
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_double):
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jump_start")
		jump_start = true
		
		if not is_on_floor():
			jump_double = false
			AudioManager.sfx1_play("jump2")
		else:
			AudioManager.sfx1_play("jump")


func _go() -> void:
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _turn() -> void:
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	
	if direction == -1.0:
		animated_sprite_2d.flip_h = true


func _invincible() -> void:
	if Input.is_action_just_pressed("invincible"):
		if not invincible:
			invincible = true
		else:
			invincible = false
