extends HurtBox
class_name EntityHurtBox
## Класс для обработки атаки [Attack] живыми существами.
##
## Этот класс предоставляет сигналы и функционал для обработки атаки [Attack]
## живыми сущностями.

## Получен урон в размере [param damage].
signal damaged(damage: int)

## Приватное поле, хранящее ссылку на дочерний узел компоненты [HP]
var _hp_component: HP = null:
	set = set_hp_component


func _ready():
	for node in get_children():
		if node is HP:
			assert(_hp_component == null, "Найдено несколько компонентов HP")
			_hp_component = node
	assert(_hp_component != null, "Не найден компонент HP")


## Обрабатывает входящую атаку [param Attack].
func _process_attack(attack: Attack) -> void:
	_hp_component.deal_damage(attack.damage)


## Setter для приватного поля [member _hp_component]. Позволяет только
## инициализировать переменную. При попытке изменить существующее значение
## или если [param value] не является [HP], то поднимает предупреждение.
func set_hp_component(value):
	if (_hp_component != null):
		push_warning("Попытка изменить приватное поле")
	elif (value is HP):
		_hp_component = value as HP
	else:
		push_warning("Попытка присвоить узел, отличный от HP")
