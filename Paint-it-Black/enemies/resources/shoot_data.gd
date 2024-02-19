class_name ShootData
extends Resource
## Этот класс отвечает за хранение параметров для стрельбы.

## Снаряд, используемый при стрельбе.
@export var projectile: PackedScene
## Время между выстрелами.
@export_range(0, 5, 0.1, "or_greater") var cooldown: float
## Угол разброса снарядов, в градусах.
@export_range(0, 10, 0.01) var spread_angle: float


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "ShootData"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false.
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)
