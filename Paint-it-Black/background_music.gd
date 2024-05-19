class_name BackgroundMusic
extends Node

var is_combat_music := false
var is_menu_music := false


func _ready() -> void:
	play_menu_music()


func play_menu_music() -> void:
	is_menu_music = true
	is_combat_music = false
	if $CombatMusic.playing:
		$CombatMusic.stop()
	$MenuMusic.play()


func play_combat_music() -> void:
	is_combat_music = true
	is_menu_music = false
	if $MenuMusic.playing:
		$MenuMusic.stop()
	$CombatMusic.play()


func _repeate_combat_loop() -> void:
	if not is_combat_music:
		return
	play_combat_music()


func _repeate_menu_loop() -> void:
	if not is_menu_music:
		return
	play_menu_music()
