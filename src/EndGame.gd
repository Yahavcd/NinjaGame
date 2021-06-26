extends Node

var points

func _ready():
	points = gamestate.points
	$Control/VBoxContainer/Score.text = "Your Score: " + String(points)

func _on_Button_pressed():
	gamestate.points = 0
	gamestate.lives = 1
	gamestate.is_hit = false
	get_tree().change_scene("res://Scenes/Boards/BoredTemplet.tscn")
