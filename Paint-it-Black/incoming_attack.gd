class_name IncomingAttack
extends Resource
## Этот ресурс отвечает за передачу параметров атаки, необходимых для её
## обработки в [HurtBoxInterface].

## Количество наносимого урона.
var damage: int


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "IncomingAttack"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)
