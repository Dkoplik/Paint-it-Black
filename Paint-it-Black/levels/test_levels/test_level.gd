extends Node

func _unhandled_input(event):
	if event is InputEventMouseButton:
		GameManager.hit_stop(0.05, 1)
