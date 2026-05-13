extends "res://scripts/player.gd"

var is_on_floor = false
var jump_ = false
var invincible_  = false

func _on_floor() -> void:
	if is_on_floor:
		if jump_in:
			animated_sprite_2d.play("jump_end")
			AudioManager.sfx1_play("hit")
		elif direction:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")

func _jump() -> void:
	if jump_ and (is_on_floor or jump_double):
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jump_start")
		jump_start = true
		
		if not is_on_floor:
			jump_double = false
			AudioManager.sfx1_play("jump2")
		else:
			AudioManager.sfx1_play("jump")

func _invincible() -> void:
	if invincible_:
		if not invincible:
			invincible = true
		else:
			invincible = false
