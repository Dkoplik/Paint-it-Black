@tool
class_name SpawnPoint
extends CustomNode2D

## Что делать и в каком порядке? Действия выполняются от 0-ого до последнего.
@export var actions_order: Array[SpawnPointAction]
## Стандартное время ожидания между действиями.
@export var default_wait_time := 0.5
## Включена ли точка спавна. Если false, то ничего не происходит.
@export var enabled: bool = false:
	set = set_enabled

## Маркер, на котором будут спавниться сцены.
var _spawning_marker: Marker2D
## Было ли уже ожидание следующего действия?
var _has_waited := false
## Началось ли выполнение какого-либо действия?
var _is_action_started := false
## Есть ли в массиве какие-либо действия?
var _has_actions := false


func _ready() -> void:
	super()
	actions_order.reverse()
	_spawning_marker = $"SpawnPointMarker"
	_prepare_spawn_actions()


func _physics_process(_delta):
	if Engine.is_editor_hint():
		return

	_process_actions()


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_check_any_action(warnings)
	return _has_actions


func set_enabled(value: bool) -> void:
	if value == false:
		push_warning("Точка спавна не рассчитана на отключение, могут быть баги.")
	enabled = value
	# ToDo обработка массива


## Включает точку спавна.
func enable() -> void:
	enabled = true


func _process_actions() -> void:
	if actions_order.is_empty():
		return
	
	if _is_action_started:
		return

	_is_action_started = true
	var current_action = actions_order.back()
	await _process_waiting(current_action)

	var is_action_successful: bool = await current_action.do_action()
	while not is_action_successful:
		is_action_successful = await current_action.do_action()

	if not current_action.is_class_name(&"WaitAction"):
		_has_waited = false
	actions_order.pop_back()
	_is_action_started = false


## Обработка ожидания между действиями. Учитывает стандартное время ожидания
## и кастомное через действия ожидания.
func _process_waiting(current_action) -> void:
	if _has_waited:
		return

	if current_action.is_class_name(&"WaitAction"):
		_has_waited = true
		return

	await AutoloadUtilities.wait_for(default_wait_time)
	_has_waited = true


## Содержит ли массив действий хотя бы какое-то действие?
func _check_any_action(warnings: PackedStringArray = []) -> void:
	_has_actions = not actions_order.is_empty()
	if not _has_actions:
		if Engine.is_editor_hint():
			warnings.push_back("Список действий пуст")
		else:
			push_warning("Список действий пуст")


func _prepare_spawn_actions() -> void:
	for action in actions_order:
		if action.is_class_name(&"SpawnSceneAction"):
			action.spawning_marker = _spawning_marker
