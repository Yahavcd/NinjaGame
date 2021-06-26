extends Node2D

export (PackedScene) var bullet_scene

export var turn_spawn = 3
export var turn_amount = 3

const TOP = 1
const RIGHT = 2
const LEFT = 3
const BOTTOM = 4

var spawn_side
var current_position
var bullet
var signal_rotation
var signal_velocity = Vector2(1,0)
var turn_count = 1

func _ready():
	randomize()
	current_position = $EnemySpawn/SpwanPath

func spawn_location():
	spawn_side = (randi() % 4 + 1)
	if spawn_side == TOP:
		current_position.offset = ((randi() % 7 + 2)* gamestate.TILE_SIZE)
		fix_spawn_pos()
			
	elif spawn_side == LEFT:
		current_position.offset = ((randi() % 10 + 11) * gamestate.TILE_SIZE)
		fix_spawn_pos()
			
	elif spawn_side == RIGHT:
		current_position.offset = ((randi() % 7 + 23) * gamestate.TILE_SIZE)
		fix_spawn_pos()
			
	else:
		current_position.offset = ((randi() % 10 + 32) * gamestate.TILE_SIZE)
		fix_spawn_pos()

func fix_spawn_pos():
	current_position.position.x = round(current_position.position.x)
	current_position.position.y = round(current_position.position.y)
	
	if int(current_position.position.x) % gamestate.TILE_SIZE != 0:
		current_position.position.x = round(current_position.position.x / gamestate.TILE_SIZE) * gamestate.TILE_SIZE
	if int(current_position.position.y) % gamestate.TILE_SIZE != 0:
		current_position.position.y = round(current_position.position.y / gamestate.TILE_SIZE) * gamestate.TILE_SIZE

func spwn():
	bullet = bullet_scene.instance()
	get_node("Enemies").add_child(bullet)
	bullet.position = current_position.position
	bullet.rotation = current_position.rotation
	bullet.get_node("sprite!_mark").rotation_degrees = signal_rotation
	bullet.initial_position = bullet.position
	bullet.input_direction = signal_velocity.rotated(current_position.rotation)

func _on_PlayerTemplate_moving():
	turn_count -=1
	get_tree().call_group("Bullets", "moving")
	if turn_count == 0:
		var count = 0
		while count < turn_amount:
			spawn_location()
			rotate_bullet()
			spwn()
			count += 1
		turn_count = turn_spawn

func rotate_bullet():
	
	if spawn_side == TOP:
		current_position.rotation = deg2rad(90)
		signal_rotation = 270
		
	if spawn_side == RIGHT:
		current_position.rotation = deg2rad(270)
		signal_rotation = 90

	if spawn_side == LEFT:
		current_position.rotation = deg2rad(180)
		signal_rotation = 180
		
	if spawn_side == BOTTOM:
		current_position.rotation = deg2rad(360)
		signal_rotation = 0

func _on_PlayerTemplate_stop_moving():
	$box.hide()
	$box.position = $PlayerTemplate.position
	$box.show()
