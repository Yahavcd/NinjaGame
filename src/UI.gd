extends Node2D

var points = 0

func on_move():
	points = gamestate.points
	$Score.text = "Score: " + String(points)
