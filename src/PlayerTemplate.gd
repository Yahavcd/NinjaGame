extends Area2D

export var walk_speed = 4.0

var initial_position = Vector2(0,0)
var input_direction = Vector2(0,0)
var is_moving = false
var percent_moved_to_next_tile = 0.0

signal moving

func _ready():
	initial_position = position

func _physics_process(delta):
	if is_moving == false:
		process_player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false

func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	
	if (global_position.y == 288 and input_direction.y > 0) or (global_position.y == 0 and input_direction.y < 0):
		input_direction.y = 0
	if (global_position.x == 192 and input_direction.x > 0) or (global_position.x == 0 and input_direction.x < 0):
		input_direction.x = 0
	
	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true
		emit_signal("moving")
		$AudioStreamPlayer.play()

func move(delta):
	$AnimationPlayer.play("New Anim")
	percent_moved_to_next_tile += walk_speed * delta
	
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + (gamestate.TILE_SIZE * input_direction)
		percent_moved_to_next_tile = 0
		is_moving = false
		points_up()
	else:
		position = initial_position + (gamestate.TILE_SIZE * input_direction * percent_moved_to_next_tile)

func _on_PlayerTemplate_area_entered(_area):
	gamestate.is_hit = true
	gamestate.lives -= 1
	if gamestate.lives == 0:
		get_tree().change_scene("res://Scenes/UI/EmdGame.tscn")

func points_up():
	if gamestate.is_hit != true:
		gamestate.points += 1
		gamestate.is_hit = false
		get_tree().call_group("UI","on_move")
