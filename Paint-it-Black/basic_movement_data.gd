class_name BasicMovementData
extends Resource
## Набор параметров для класса [BasicCharacterMovement].
##
## Этот ресурс содержит основные параметры для движения и падения, которые
## нужны для работы компоненты [BasicCharacterMovement].

## Параметры ходьбы / бега
@export_group("Moving")
## Ускорение движения
@export_range(0, 100, 0.1, "or_greater") var movement_acceleration: float
## Максимальная развиваемая скорость движения
@export_range(0, 100, 0.1, "or_greater") var max_movement_speed: float

## Параметры падения
@export_group("Falling")
## Действующая гравитация
@export_range(0, 100, 0.1, "or_greater")
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
## Максимальная развиваемая скорость падения
@export_range(0, 100, 0.1, "or_greater") var max_fall_speed: float


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "BasicMovementData"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)
