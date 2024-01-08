@tool
class_name HPData
extends Resource
## Этот ресурс хранит параметры, связанные с жизнями персонажа.
##
## Этот ресурс отвечает за максимальное количество жизней и на их изначальное
## количество. Обращаю внимание, что текущие жизни не имеют к этому ресурсу
## никакого отношение, поскольку они не являются задаваемым параметром.

## Максимальное количество жизней персонажа
@export var max_hp: int:
	set = set_max_hp,
	get = get_max_hp
## Изначальное количество жизней персонажа
@export var initial_hp: int:
	set = set_initial_hp,
	get = get_initial_hp


## Setter для поля [member max_hp]. Не позволяет значению поля выйти за границы
## диапазона [0..100], а также перепроверяет значение initial_hp.
func set_max_hp(value: int) -> void:
	max_hp = max(0, value)
	max_hp = min(max_hp, 100)
	# Вызов setter для initial_hp, чтобы оно не превисило max_hp
	initial_hp = initial_hp


## Getter для поля [member max_hp]
func get_max_hp() -> int:
	return max_hp


## Setter для поля [member initial_hp]. Не позволяет значению
## [member initial_hp] быть меньше 0 или превысить значение [member max_hp].
func set_initial_hp(value: int) -> void:
	initial_hp = max(0, value)
	initial_hp = min(initial_hp, max_hp)


## Getter для поля [member initial_hp].
func get_initial_hp() -> int:
	return initial_hp
