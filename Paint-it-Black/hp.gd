@tool
class_name HP
extends CustomNode
## Узел, отвечающий за обработку очков здоровья.
##
## Данный узел отвечает за очки здоровья персонажей, то есть хранит их
## количество и предоставляет функции для их изменения.

## Количество текущих жизней [member _current_hp] равно 0.
signal killed

## Количество текущих жизней [member _current_hp] изменилось с
## [param previous_hp] на [param new_hp].
signal hp_changed(previous_hp: int, new_hp: int)

## Данные о жизнях персонажа.
@export var hp_data: HPData:
	set = set_hp_data

## Есть ли ссылка на [member hp_data].
var _has_hp_data := false
## Текущее количество очков здоровья. При старте значение приравнивается
## значению [member initial_hp].
var _current_hp: int:
	get = get_current_hp,
	set = set_current_hp


func _init() -> void:
	_class_name = &"HP"


func _ready():
	update_configuration_warnings()
	if _has_hp_data:
		_current_hp = hp_data.initial_hp


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	_has_hp_data = Utilities.check_reference(hp_data, "HPData", warnings)
	return warnings


## Setter для [member hp_data]. Обновляет ошибки конфигурации.
func set_hp_data(value: HPData) -> void:
	hp_data = value
	update_configuration_warnings()


## Setter для приватного поля [member _current_hp], устанавливает его
## значение равное значению [param value], не допуская выход за границы
## от 0 до [member max_hp].
func set_current_hp(value: int) -> void:
	if !_has_hp_data:
		push_error("Невозможно использовать set_current_hp() без HPData")
		return

	if value < 0:
		value = 0
	if value > hp_data.max_hp:
		value = hp_data.max_hp

	hp_changed.emit(_current_hp, value)
	_current_hp = value
	if _current_hp == 0:
		killed.emit()


## Getter для приватного поля [member _current_hp], возвращает его значение.
func get_current_hp() -> int:
	return _current_hp


## Восстанавливает количество текущих жизней [member _current_hp] на значение
## [param value], при этом не позволяет превысить границу [member max_hp].
## Возвращает новое значение [member _current_hp].
func restore_hp(value: int) -> int:
	if !_has_hp_data:
		push_error("Невозможно использовать restore_hp() без HPData")
		return _current_hp

	if value < 0:
		push_error("Попытка восстановить hp на отрицательное значение")
		return _current_hp

	_current_hp = min(_current_hp + value, hp_data.max_hp)
	return _current_hp


## Полностью восстанавливает количество текущих жизней [member _current_hp], то
## есть приравнивает их к значению [member max_hp].
func full_restore_hp() -> void:
	if !_has_hp_data:
		push_error("Невозможно использовать full_restore_hp() без HPData")
		return

	_current_hp = hp_data.max_hp


## Убавляет количество текущих жизней [member _current_hp] на значение
## [param value], при этом не позволяет выйти за границу 0.
## Возвращает новое значение [member _current_hp].
func deal_damage(value: int) -> int:
	if value < 0:
		push_error("Попытка нанести урон на отрицательное значение")
		return _current_hp

	_current_hp = max(_current_hp - value, 0)
	return _current_hp


## Полностью убавляет количество текущих жизней [member _current_hp], то
## есть приравнивает их к значению 0.
func kill() -> void:
	_current_hp = 0
