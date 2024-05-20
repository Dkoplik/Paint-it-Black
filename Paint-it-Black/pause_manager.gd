extends Control


func _ready():
	hide()

func _physics_process(_delta):
	var camera = get_tree().root.get_camera_2d()
	if camera:
		global_position = camera.get_screen_center_position()


func _input(event):
	if event.is_action_pressed("esc"):
		switch_pause()


func switch_pause() -> void:
	if GameManager.is_player_dead:
		return

	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		show()
	else:
		hide()


func _on_continue_button_pressed():
	switch_pause()


func _on_exit_to_main_menu_button_pressed():
	switch_pause()
	LevelManager.load_main_menu()


func _on_exit_game_button_pressed():
	get_tree().quit()
