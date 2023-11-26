extends Node

@onready var pause_menu = $"../PauseMenu"

var game_paused: bool = false

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		game_paused = !game_paused
		
	if game_paused == true:
		get_tree().paused = true
		pause_menu.show()
	else:
		get_tree().paused = false
		pause_menu.hide()
		
