extends GutTest

var level_scene
var player

func before_each():
	level_scene = load("res://scenes/level_1.tscn").instantiate()
	add_child(level_scene)

	await get_tree().process_frame

	player = level_scene.Player


func after_each():
	level_scene.queue_free()


func test_secret_entered_adds_result_and_removes_texture():
	level_scene.result = 1
	level_scene.secret_texture.texture = level_scene.pizza

	level_scene._on_secret_entered(player)

	assert_eq(level_scene.result, 2)
	assert_null(level_scene.secret_texture.texture)


func test_death_resets_player_position_secret_and_result():
	level_scene.spawn_position = Vector2(100, 200)
	level_scene.result = 2
	level_scene.secret_texture.texture = null
	player.invincible = false
	player.position = Vector2(500, 500)

	level_scene._death(player)

	assert_eq(player.position, Vector2(100, 200))
	assert_not_null(level_scene.secret_texture.texture)
	assert_eq(level_scene.result, 1)


func test_death_does_not_work_when_player_is_invincible():
	level_scene.spawn_position = Vector2(100, 200)
	player.invincible = true
	player.position = Vector2(500, 500)

	level_scene._death(player)

	assert_eq(player.position, Vector2(500, 500))


func test_oven_entered_adds_result_if_timer_not_zero():
	level_scene.result = 1
	level_scene.level_number = 1
	level_scene.timer.set_time(0, 10)

	level_scene._on_oven_entered(player)

	assert_eq(level_scene.result, 2)


func test_oven_entered_does_not_add_result_if_timer_is_zero():
	level_scene.result = 1
	level_scene.level_number = 1
	level_scene.timer.set_time(0, 0)

	level_scene._on_oven_entered(player)

	assert_eq(level_scene.result, 1)
