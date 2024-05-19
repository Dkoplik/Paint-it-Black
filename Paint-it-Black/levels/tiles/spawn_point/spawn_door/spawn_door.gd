extends Node2D

## Дверь открылась.
signal opened
## Дверь закрылась.
signal closed

## Закрыта ли дверь?
@export var is_closed := true:
	set = set_is_closed
@export var animation_duration := 1.0

const CLOSED_FRAME_NUM := 0
const OPENED_FRAME_NUM := 5
const ANIMATION_NAME := &"door_anim"

@onready var animated_sprite := $AnimatedSprite2D

var _is_node_ready := false


func _ready() -> void:
	_is_node_ready = true
	if is_closed:
		_set_closed_state()
	else:
		_set_open_state()


func set_is_closed(value: bool) -> void:
	if is_closed == value:
		return

	is_closed = value

	if not _is_node_ready:
		return

	if is_closed:
		_play_close_anim()
	else:
		_play_open_anim()


func open() -> void:
	is_closed = false


func close() -> void:
	is_closed = true


func _set_open_state() -> void:
	animated_sprite.set_frame_and_progress(OPENED_FRAME_NUM, 0.0)


func _set_closed_state() -> void:
	animated_sprite.set_frame_and_progress(CLOSED_FRAME_NUM, 0.0)


func _play_open_anim() -> void:
	animated_sprite.play(ANIMATION_NAME, 1.0 / animation_duration)


func _play_close_anim() -> void:
	animated_sprite.play(ANIMATION_NAME, -1.0 / animation_duration, true)
