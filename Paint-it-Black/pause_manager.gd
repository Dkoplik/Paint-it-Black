extends Control

func _ready():
	hide()


func _input(event):
	if event.is_action_pressed("esc"):	
		switch_pause()


func switch_pause() -> void:
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		show()
	else:
		hide()


func _on_continue_button_pressed():
	switch_pause()

func _on_exit_to_main_menu_button_pressed():
	switch_pause()
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_exit_game_button_pressed():
	get_tree().quit()
