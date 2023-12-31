extends Area2D
class_name HurtBoxInterface
## Условный интерфейс для всех hurt-box'ов в игре.
##
## Этот класс содержит сигналы, поля и метод, необходимые любому hurt-box в
## игре. При этом каждый наследник должен переопределить метод [method _hurt].

## Испускается, когда была получена атака. [param attack] передаёт параметры
## входящей атаки.
signal hurt(attack: AttackData)

## Приватное поле. Содержит ссылку на компоненту [HP], необходимую для работы
## [HurtBoxInterface]. При отсутсвии [HP] выполнение скрипта прерывается.
var _hp: HP = null


func _ready() -> void:
	for node in get_children():
		if node is HP:
			assert(_hp == null, "Найдено несколько компонентов HP")
			_hp = node
	assert(_hp != null, "Не найден компонент HP")


## Производит обработку входящей атаки и испускает сигнал [signal hurt]. Обычно
## вызывается компонентой [BasicHitBox] и её наследниками при пересечении с 
## данным [HurtBoxInterface].
func _hurt(attack: AttackData) -> void:
	# Тут ничего писать не нужно, функция будет переопределна в дочерних
	# классах.
	pass
