extends Control

@export_file("*tscn") var start_scene

func _on_play_button_pressed():
	get_tree().change_scene_to_file(start_scene)


func _on_exit_button_pressed():
	get_tree().quit()
