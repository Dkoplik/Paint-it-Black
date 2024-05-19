extends Node

## Началось прохождение комнаты.
signal room_started
## Комната завершилась, все враги закончились.
signal room_ended
## Появились враги в комнате.
signal enemies_started
## Враги в комнате закончились.
signal enemies_ended

var player: CharacterBody2D

## Номер текущей волны в активной комнате.
var wave_number := 0
## Счётчик активных точек спавна.
var active_spawn_points_count := 0:
	set = set_active_spawn_points_count
## Счётчик точек спавна с активной волной.
var active_waves_count := 0:
	set = set_active_waves_count
## Счёчтик живых врагов.
var enemies_count := 0:
	set = set_enemies_count

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


func set_active_spawn_points_count(value: int) -> void:
	if value < 0:
		push_error("Попытка сделать отрицательным счётчик активных точек спавна")
		return

	if active_spawn_points_count == 0 and value > 0:
		wave_number = 0
		room_started.emit()
	if active_spawn_points_count > 0 and value == 0:
		_check_room_ended()
	active_spawn_points_count = value


func increase_active_spawn_points_count() -> void:
	active_spawn_points_count += 1


func decrease_active_spawn_points_count() -> void:
	active_spawn_points_count -= 1


func set_active_waves_count(value: int) -> void:
	if value < 0:
		push_error("Попытка сделать отрицательным счётчик спавнов с активной волной")
		return

	if active_waves_count > 0 and value == 0:
		_check_wave_ended()
	active_waves_count = value


func increase_active_waves_count() -> void:
	active_waves_count += 1


func decrease_active_waves_count() -> void:
	active_waves_count -= 1


func set_enemies_count(value: int) -> void:
	if value < 0:
		push_error("Попытка сделать отрицательным счётчик врагов")
		return

	if enemies_count == 0 and value > 0:
		enemies_started.emit()
	if enemies_count > 0 and value == 0:
		enemies_ended.emit()
	enemies_count = value

func increase_enemies_count() -> void:
	enemies_count += 1


func decrease_enemies_count() -> void:
	enemies_count -= 1


func _check_room_ended() -> void:
	await enemies_ended
	if active_spawn_points_count != 0:
		push_warning("Какой-то спавн стал активным до окончания всех врагов")
		return
	room_ended.emit()


func _check_wave_ended() -> void:
	await enemies_ended
	if active_waves_count != 0:
		push_warning("Какой-то спавн стал с активной волной до окончания всех врагов")
		return
	wave_number += 1
