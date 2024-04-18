class_name Player
extends CharacterBody2D

@export var tile_map : TileMap
@onready var camera = $Camera2D as Camera2D

func _ready() -> void:
	#Установка лимитов камеры на границах уровня
	var r = tile_map.get_used_rect()
	var vp = tile_map.get_viewport_rect()
	var qs = tile_map.cell_quadrant_size
	camera.limit_left = r.position.x * qs
	camera.limit_top = r.position.y * qs
	camera.limit_right = r.end.x * qs
	camera.limit_bottom = r.end.y * qs

func _process(delta):
	pass


