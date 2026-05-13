extends GutTest

var PlayerScene = preload("res://unit_testing/unit_player.tscn")

func test_animation_finished_jump_start():
	var player = PlayerScene.instantiate()
	add_child(player)

	await get_tree().process_frame

	player.animated_sprite_2d.play("jump_start")
	player._on_animated_sprite_2d_animation_finished()

	assert_true(player.jump_in)
	assert_false(player.jump_start)

func test_animation_finished_jump_end():
	var player = PlayerScene.instantiate()
	add_child(player)

	await get_tree().process_frame

	player.animated_sprite_2d.play("jump_end")
	player._on_animated_sprite_2d_animation_finished()

	assert_false(player.jump_in)
	assert_true(player.jump_double)
	
func test_jump():
	var player = PlayerScene.instantiate()
	add_child(player)
	player.jump_= true
	player.is_on_floor = true
	
	player._jump()
	
	assert_true(player.jump_start)
	assert_true(player.jump_double)
	
func test_double_jump():
	var player = PlayerScene.instantiate()
	add_child(player)
	player.jump_= true
	player.is_on_floor = false
	
	player._jump()
	
	assert_true(player.jump_start)
	assert_false(player.jump_double)
	
func test_invincible():
	var player = PlayerScene.instantiate()
	add_child(player)
	player.invincible_ = true
	
	player._invincible()
	assert_true(player.invincible)
	
	player._invincible()
	assert_false(player.invincible)
