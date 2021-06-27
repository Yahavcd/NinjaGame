extends Node

var points

func _ready():
	points = gamestate.points
	$Control/VBoxContainer/Score.text = "Your Score: " + String(points)

func _on_Button_pressed():
	init()
	get_tree().change_scene("res://Scenes/Boards/BoredTemplet.tscn")


func _on_Button2_pressed():
	init()
	get_tree().change_scene("res://Scenes/UI/StartGame.tscn")

func init():
	gamestate.points = 0
	gamestate.lives = 1
	gamestate.is_hit = false
