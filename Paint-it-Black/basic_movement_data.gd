extends Resource
class_name BasicMovementData
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
@export_range(0, 100, 0.1, "or_greater") var gravity: float =\
ProjectSettings.get_setting("physics/2d/default_gravity")
## Максимальная развиваемая скорость падения
@export_range(0, 100, 0.1, "or_greater") var max_fall_speed: float
