class_name AttackData
extends Resource
## Этот класс отвечает за базовые параметры атаки.

## Количество наносимого урона.
@export_range(0, 20, 1, "or_greater") var damage: int


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "AttackData"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)
