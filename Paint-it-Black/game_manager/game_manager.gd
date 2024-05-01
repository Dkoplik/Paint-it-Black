extends Node

var player: CharacterBody2D

var _hit_stop_resource = preload("res://game_manager/game_manager_resource.tres")
## Действует ли сейчас hit_stop?
var _is_hit_stop := false


func hit_stop(time_scale: float, duration: float) -> void:
	if _is_hit_stop:
		return

	_is_hit_stop = true
	var initial_time_scale := Engine.time_scale

	Engine.time_scale = time_scale
	await AutoloadUtilities.wait_for(duration * time_scale)
	Engine.time_scale = initial_time_scale

	_is_hit_stop = false


func on_parry_hit_stop() -> void:
	var time_scale: float = _hit_stop_resource.time_scale
	var duration: float = _hit_stop_resource.parry_stop_duration
	hit_stop(time_scale, duration)


func on_hurt_hit_stop() -> void:
	var time_scale: float = _hit_stop_resource.time_scale
	var duration: float = _hit_stop_resource.hurt_stop_duration
	hit_stop(time_scale, duration)


func on_hit_hit_stop() -> void:
	var time_scale: float = _hit_stop_resource.time_scale
	var duration: float = _hit_stop_resource.hit_stop_duration
	hit_stop(time_scale, duration)
