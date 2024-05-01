extends Node

## Типы уровней (сцен).
enum LevelType { MAIN_MENU, DEFAULT, GAME_LEVEL }

## Данные о всех уровнях.
var levels_resource: LevelsResource = preload("res://levels/level_manager/levels_resource.tres")

## Тип текущего уровня.
var _current_lvl_type: LevelType:
	get = get_current_lvl_type
## Номер текущего игрового уровня. Если сейчас не игровой уровень, то значение
## равно -1.
var _current_game_lvl: int:
	get = get_current_game_lvl
## Идёт ли какая-то загрузка?
var _waiting_to_load := false
## Путь загружаемой сцены.
var _loading_path: String


func _physics_process(_delta):
	if not _waiting_to_load:
		return

	if (
		ResourceLoader.load_threaded_get_status(_loading_path)
		== ResourceLoader.THREAD_LOAD_IN_PROGRESS
	):
		return
	if ResourceLoader.load_threaded_get_status(_loading_path) == ResourceLoader.THREAD_LOAD_LOADED:
		await _fade_out()
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(_loading_path))
	else:
		push_error("Загрузка уровня не удалась")
	_waiting_to_load = false


func get_current_lvl_type() -> LevelType:
	return _current_lvl_type


func get_current_game_lvl() -> int:
	return _current_game_lvl


## Загружает и устанавливает указанный игровой уровень. Если [param value] за
## пределами массива игровых уровней, то загружается сцена по-умолчанию.
func load_lvl(value: int):
	if not _is_valid_lvl_num(value):
		load_default_scene()
	else:
		await _fade_in()
		get_tree().change_scene_to_packed(levels_resource.loading_sceen)
		_loading_path = levels_resource.levels[value]
		ResourceLoader.load_threaded_request(_loading_path)
		_waiting_to_load = true
		_current_game_lvl = value
		_current_lvl_type = LevelType.GAME_LEVEL


func _fade_in():
	var fading = _add_fading()
	fading.fade_in()
	await fading.faded_in
	fading.queue_free()


func _fade_out():
	var fading = _add_fading()
	fading.fade_out()
	await fading.faded_out
	fading.queue_free()


func _add_fading():
	var fading = levels_resource.fading_screen.instantiate()
	var camera = get_viewport().get_camera_2d()
	if camera == null:
		camera = get_tree().root
	camera.add_child(fading)
	return fading


## Загружает следующий игровой уровень. Если текущий уровень был не игровым, то
## загружает нулевой уровень. Если следующего игрового уровня нет, загружает
## сцену по-умолчанию.
func next_lvl() -> void:
	load_lvl(_current_game_lvl + 1)


## Загружает предыдущий игровой уровень. Если текущий уровень был не игровым, то
## загружает сцену по-умолчанию.
func prev_lvl() -> void:
	load_lvl(_current_game_lvl - 1)


## Загрузить и установить сцену главного меню.
func load_main_menu() -> void:
	_current_game_lvl = -1
	_current_lvl_type = LevelType.MAIN_MENU
	get_tree().change_scene_to_packed(levels_resource.main_menu)


## Загрузить и установить сцену по-умолчанию.
func load_default_scene() -> void:
	_current_game_lvl = -1
	_current_lvl_type = LevelType.DEFAULT
	get_tree().change_scene_to_packed(levels_resource.default_scene)


func _is_valid_lvl_num(lvl_num: int) -> bool:
	return lvl_num >= 0 and lvl_num < levels_resource.levels.size()
