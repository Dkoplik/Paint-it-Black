class_name HP
extends Node
## Узел, отвечающий за обработку очков здоровья.
##
## Данный узел отвечает за очки здоровья персонажей, то есть хранит их
## количество и предоставляет функции для их изменения, возможно, избыточные.

## Количество текущих жизней [member current_hp] достигло 0
signal killed

## Количество текущих жизней [member current_hp] изменилось с
## [param previous_hp] на [param new_hp]
signal hp_changed(previous_hp: int, new_hp: int)

## Данные о жизнях персонажа.
@export var hp_data: HPData

## Текущее количество очков здоровья. При старте значение приравнивается
## значению [member initial_hp].
var current_hp: int:
	get = get_current_hp,
	set = set_current_hp


func _ready():
	assert(hp_data != null, "Отсутствует HPData")
	current_hp = hp_data.initial_hp


## Setter для приватного поля [member current_hp], устанавливает его
## значение равное значению [param value], не допуская выход за границы
## от 0 до [member max_hp].
func set_current_hp(value: int) -> void:
	if value < 0:
		value = 0
	elif value > hp_data.max_hp:
		value = hp_data.max_hp
	hp_changed.emit(current_hp, value)
	current_hp = value
	if current_hp == 0:
		killed.emit()


## Getter для приватного поля [member current_hp], возвращает его значение.
func get_current_hp() -> int:
	return current_hp


## Восстанавливает количество текущих жизней [member current_hp] на значение
## [param value], при этом не позволяет превысить границу [member max_hp].
## Возвращает новое значение [member current_hp].
func restore_hp(value: int) -> int:
	assert(value > 0)
	current_hp += value
	if current_hp > hp_data.max_hp:
		current_hp = hp_data.max_hp
	return current_hp


## Полностью восстанавливает количество текущих жизней [member current_hp], то
## есть приравнивает их к значению [member max_hp].
func full_restore_hp() -> void:
	current_hp = hp_data.max_hp


## Убавляет количество текущих жизней [member current_hp] на значение
## [param value], при этом не позволяет выйти за границу 0.
## Возвращает новое значение [member current_hp].
func deal_damage(value: int) -> int:
	assert(value > 0)
	current_hp -= value
	if current_hp < 0:
		current_hp = 0
	return current_hp


## Полностью убавляет количество текущих жизней [member current_hp], то
## есть приравнивает их к значению 0.
func kill() -> void:
	current_hp = 0
