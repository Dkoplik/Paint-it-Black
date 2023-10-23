extends HurtBox
class_name EntityHurtBox
## Класс для обработки атаки [Attack] живыми существами.
##
## Этот класс предоставляет сигналы и функционал для обработки атаки [Attack]
## живыми сущностями.

## Получен урон в размере [param damage].
signal damaged(damage: int)

## Приватное поле, хранящее ссылку на дочерний узел компоненты [HP]
var _hp_component: HP: set = set_hp_component


func _ready():
	# ToDo: найти дочерний узел HP. Если их несколько, то бросить ошибку через
	# push_error(). Если нет ни одного, то тоже бросить ошибку через
	# push_error()
	pass


func set_hp_component(value):
	if (_hp_component != null):
			push_warning("Попытка изменить приватное поле")
	elif (value is HP):
		_hp_component = value as HP


## Обрабатывает входящую атаку [param Attack].
func _process_attack(attack: Attack) -> void:
	# ToDo: сделать обработку урона. Урон получить из attack и применить к
	# компоненте hp (стоит посмотреть документацию по HP через справка > HP).
	pass
