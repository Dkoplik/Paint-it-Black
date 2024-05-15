extends Node2D

## Дверь открылась.
signal opened
## Дверь закрылась.
signal closed

## Закрыта ли дверь?
@export var is_closed := true:
	set = set_is_closed
@export var animation_duration := 1.0

const UPPER_PART_CLOSED_POSITION := Vector2(0, -20)
const UPPER_PART_OPENED_POSITION := Vector2(0, -60)

const LOWER_PART_CLOSED_POSITION := Vector2(0, 20)
const LOWER_PART_OPENED_POSITION := Vector2(0, 60)

const CLOSED_FRAME_NUM := 0
const OPENED_FRAME_NUM := 4
const ANIMATION_NAME := &"door_anim"

@onready var animated_sprite := $AnimatedSprite2D
@onready var upper_collision: CollisionShape2D = $AnimatableBody2D/UpperCollision
@onready var lower_collision: CollisionShape2D = $AnimatableBody2D/LowerCollision

var _upper_tween: Tween
var _lower_tween: Tween
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
	upper_collision.position = UPPER_PART_OPENED_POSITION
	lower_collision.position = LOWER_PART_OPENED_POSITION


func _set_closed_state() -> void:
	animated_sprite.set_frame_and_progress(CLOSED_FRAME_NUM, 0.0)
	upper_collision.position = UPPER_PART_CLOSED_POSITION
	lower_collision.position = LOWER_PART_CLOSED_POSITION


func _play_open_anim() -> void:
	animated_sprite.play(ANIMATION_NAME, 1.0 / animation_duration)
	_reset_tweens()
	_upper_tween.tween_property(upper_collision, "position", UPPER_PART_OPENED_POSITION, animation_duration)
	_lower_tween.tween_property(lower_collision, "position", LOWER_PART_OPENED_POSITION, animation_duration)


func _play_close_anim() -> void:
	animated_sprite.play(ANIMATION_NAME, -1.0 / animation_duration, true)
	_reset_tweens()
	_upper_tween.tween_property(upper_collision, "position", UPPER_PART_CLOSED_POSITION, animation_duration)
	_lower_tween.tween_property(lower_collision, "position", LOWER_PART_CLOSED_POSITION, animation_duration)


func _reset_tweens() -> void:
	if _upper_tween:
		_upper_tween.kill()
	if _lower_tween:
		_lower_tween.kill()
	_upper_tween = create_tween()
	_lower_tween = create_tween()
