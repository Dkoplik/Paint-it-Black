extends Node
class_name HP
## Узел, отвечающий за обработку очков здоровья.
##
## Данный узел отвечает за очки здоровья персонажей, то есть хранит их
## количество и предоставляет функции для их изменения, возможно, избыточные.

## Количество текущих жизней [member current_hp] достигло 0
signal killed

## Количество текущих жизней [member current_hp] изменилось с
## [param previous_hp] на [param new_hp]
signal hp_changed(previous_hp: int, new_hp: int)

## Максимально возможное количество жизней
@export var max_hp: int # ToDo: через export_range сделать так, чтобы max_hp
						# нельзя было поставить ниже 0

## Стартовое значение очков здоровья при запуске узла.
@export var initial_hp: int # ToDo: значение можно поставить от 0 до max_hp

## Текущее количество очков здоровья. При старте значение приравнивается
## значению [member initial_hp].
var current_hp: int:
	get = get_current_hp, set = set_current_hp


func _ready():
	# ToDo присвоить current_hp начальное значение, причём если оно 0,
	# то ещё испустить сигнал killed (а то будет какой-то мёртворождённый)
	pass 


## Setter для приватного поля [member current_hp], устанавливает его
## значение равное значению [param value], не допуская выход за границы
## от 0 до [member max_hp].
func set_current_hp(value: int) -> void:
	# ToDo, причём если ставится значение 0, то нужно запустить сигнал killed
	# Также для любой смены значения нужно испускать сигнал hp_changed с
	# соответствующими параметрами
	pass


## Getter для приватного поля [member current_hp], возвращает его значение.
func get_current_hp() -> int:
	return current_hp


## Восстанавливает количество текущих жизней [member current_hp] на значение
## [param value], при этом не позволяет превысить границу [member max_hp].
## Возвращает новое значение [member current_hp].
func restore_hp(value: int) -> int:
	# ToDo, не забыть про проверку value > 0 и испускание сигналов
	return 0


## Полностью восстанавливает количество текущих жизней [member current_hp], то
## есть приравнивает их к значению [member max_hp].
func full_restore_hp() -> void:
	# ToDo, не забыть про испускание сигналов
	pass


## Убавляет количество текущих жизней [member current_hp] на значение
## [param value], при этом не позволяет выйти за границу 0.
## Возвращает новое значение [member current_hp].
func deal_damage(value: int) -> int:
	# ToDo, не забыть про проверку value > 0 и испускание сигналов
	return 0


## Полностью убавляет количество текущих жизней [member current_hp], то
## есть приравнивает их к значению 0.
func kill() ->  void:
	# ToDo, не забыть про испускание сигналов
	pass
