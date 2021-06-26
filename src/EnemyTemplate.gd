extends Area2D

export var walk_speed = 4.0

var initial_position = Vector2(0,0)
var input_direction = Vector2(0,0)
var percent_moved_to_next_tile = 0.0
var is_moving = false


func _physics_process(delta):
	if is_moving == false:
			if input_direction != Vector2.ZERO:
				initial_position = position
	if is_moving == true:
		move(delta)
		get_node("sprite!_mark").visible = false


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func moving():
	is_moving = true


func move(delta):
	percent_moved_to_next_tile += walk_speed * delta
	
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + (gamestate.TILE_SIZE * input_direction)
		percent_moved_to_next_tile = 0
		is_moving = false
	else:
		position = initial_position + (gamestate.TILE_SIZE * input_direction * percent_moved_to_next_tile)

