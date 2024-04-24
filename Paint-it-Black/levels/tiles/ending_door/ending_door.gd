extends Node2D

signal opened

@onready var sprite = %Door
@onready var animator = %AnimationPlayer


func open() -> void:
	sprite.play("open_anim")
	animator.play("door_open")
	opened.emit()


func _on_player_in_zone_player_entered():
	LevelManager.next_lvl()
