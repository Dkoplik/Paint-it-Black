class_name PlayerCamera
extends Camera2D

const MAX_POS_DIFF := 400.0

@export var max_cam_speed = 1000
@export var max_offset: float

@onready var root = $".."
var tile_map: TileMap


func _ready() -> void:
	_search_tile_map()
	_apply_camera_limits()


func _process(delta):
	#_move_camera_to_mouse(delta)
	pass


func _search_tile_map() -> void:
	var search_result: Array = root.get_parent().find_children("*", "TileMap", false)
	if search_result.size() == 0:
		push_error("Не найден tilemap")
	elif search_result.size() > 1:
		push_error("Найдено несколько tilemap'ов")
	else:
		tile_map = search_result[0]


func _apply_camera_limits() -> void:
	var tile_map_rect: Rect2i = tile_map.get_used_rect()
	var cell_size: int = tile_map.cell_quadrant_size
	limit_left = tile_map_rect.position.x * cell_size
	limit_top = tile_map_rect.position.y * cell_size
	limit_right = tile_map_rect.end.x * cell_size
	limit_bottom = tile_map_rect.end.y * cell_size


## Смещение камеры в сторону мышки.
func _move_camera_to_mouse(delta: float) -> void:
	var pos_diff: Vector2 = root.get_global_mouse_position() - root.global_position
	var offset_weight: float = abs(pos_diff.length()) / MAX_POS_DIFF
	var offset := clampf(lerp(0.0, max_offset, offset_weight), 0.0, max_offset)
	var offset_direction: Vector2 = pos_diff.normalized()
	position = root.position + offset * offset_direction
