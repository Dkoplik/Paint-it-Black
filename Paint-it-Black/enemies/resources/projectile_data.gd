class_name ProjectileData
extends Resource
## Этот класс отвечает за хранение параметров для снарядов.

## Урон, наносимый снарядом при столкновении.
@export_range(0, 10, 1) var damage: int
## Скорость перемещения снаряда.
@export_range(0, 200, 0.1, "or_greater") var speed: float
## Коэффициент увеличения (уменьшения) скорости при парировании.
@export_range(0, 5, 0.01, "or_greater") var parry_speed_multiplier: float


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "ProjectileData"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false.
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)
