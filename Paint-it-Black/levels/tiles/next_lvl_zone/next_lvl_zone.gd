extends Node2D

var player_in_zone: Area2D

func _ready() -> void:
	player_in_zone = $PlayerInZone
	player_in_zone.connect("player_entered", LevelManager.next_lvl)
