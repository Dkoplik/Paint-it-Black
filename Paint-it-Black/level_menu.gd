extends Control

@export_file("*tscn") var start_scene


func _on_play_button_pressed():
	LevelManager.load_lvl(0)


func _on_exit_button_pressed():
	get_tree().quit()
