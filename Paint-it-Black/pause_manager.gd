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
		


func _on_continue_button_pressed():
	game_paused = !game_paused

func _on_exit_to_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_exit_game_button_pressed():
	get_tree().quit()
