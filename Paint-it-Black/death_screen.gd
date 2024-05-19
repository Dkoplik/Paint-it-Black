extends Control


func _ready() -> void:
	visible = false


func _on_restart_button_pressed() -> void:
	LevelManager.reload_lvl()


func _on_main_menu_button_pressed() -> void:
	LevelManager.load_main_menu()
