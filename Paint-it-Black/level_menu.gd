extends Control

@export_file("*tscn") var start_scene


func _on_play_button_pressed():
	LevelManager.load_lvl(0)
	
func _on_level1_button_pressed():
	LevelManager.load_lvl(1)
	
func _on_level2_button_pressed():
	LevelManager.load_lvl(2)
	
func _on_level3_button_pressed():
	LevelManager.load_lvl(3)
	
func _on_level4_button_pressed():
	LevelManager.load_lvl(4)


func _on_exit_button_pressed():
	get_tree().quit()
