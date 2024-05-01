class_name Player
extends CharacterBody2D

@export var tile_map: TileMap
@export var max_disp_x = 150
@export var max_disp_y = 100
@export var max_cam_speed = 10000

@onready var camera = $Camera2D as Camera2D
@onready var root = $"." as CharacterBody2D


func _ready() -> void:
	#Установка лимитов камеры на границах уровня
	var r = tile_map.get_used_rect()
	var qs = tile_map.cell_quadrant_size
	camera.limit_left = r.position.x * qs
	camera.limit_top = r.position.y * qs
	camera.limit_right = r.end.x * qs
	camera.limit_bottom = r.end.y * qs


func _process(delta):
	camera_movement(delta)


##Смещение камеры в сторону курсора мыши
func camera_movement(delta):
	var r_pos = root.global_position
	var m_pos = get_global_mouse_position()
	var disp = r_pos - m_pos
	var old_pos = camera.position
	var new_pos = old_pos
	if abs(disp.x) <= max_disp_x:
		new_pos.x = m_pos.x
	else:
		new_pos.x = sign(disp.x) * -1 * max_disp_x
	if abs(disp.y) <= max_disp_x:
		new_pos.y = m_pos.y
	else:
		new_pos.y = sign(disp.y) * -1 * max_disp_y
	var disp_pos = old_pos - new_pos
	if (abs(disp_pos.x) >= max_cam_speed * delta) or (abs(disp_pos.y) >= max_cam_speed * delta):
		new_pos = (new_pos - old_pos).normalized() * max_cam_speed * delta
	camera.position = new_pos
