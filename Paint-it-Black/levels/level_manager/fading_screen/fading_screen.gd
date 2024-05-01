extends CanvasLayer

signal faded_out
signal faded_in

@export var time: float = 1.0

@onready var _tween = create_tween()
@onready var _fading = %fading


func fade_in() -> void:
	_fading.position = Vector2(2400, 264)
	_tween.tween_property(_fading, "position", Vector2(400, 264), time)
	await _tween.finished
	faded_in.emit()


func fade_out() -> void:
	_fading.position = Vector2(400, 264)
	_tween.tween_property(_fading, "position", Vector2(-2000, 264), time)
	await _tween.finished
	faded_out.emit()
