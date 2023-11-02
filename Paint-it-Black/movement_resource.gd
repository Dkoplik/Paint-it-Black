extends Resource
class_name MovementResource
## Этот ресурс отвечает за параметры передвижения.
##
## Этот ресурс будет использоваться в [MovementComponent] для задания параметров
## движения объекта.


## Параметры ходьбы / бега
@export_group("Moving")
## Ускорение движения
@export_range(0, 100, 0.1, "or_greater") var movement_acceleration: float
## Максимальная развиваемая скорость движения
@export_range(0, 100, 0.1, "or_greater") var max_movement_speed: float


## Параметры прыжка и падения
@export_group("Jumping")
## Действующая гравитация
@export_range(0, 100, 0.1, "or_greater") var gravity: float =\
ProjectSettings.get_setting("physics/2d/default_gravity")
## Начальная скорость прыжка
@export_range(0, 100, 0.1, "or_greater") var jump_speed: float
## Максимальная развиваемая скорость падения
@export_range(0, 100, 0.1, "or_greater") var max_fall_speed: float


## Параметры скольжения по стенам
@export_group("Sliding")
## Ускорение скольжения (вместо гравитации)
@export_range(0, 100, 0.1, "or_greater") var sliding_acceleration: float
## Максимальная развиваемая скорость скольжения
@export_range(0, 100, 0.1, "or_greater") var max_sliding_speed: float
## Угол прыжка при скольжении
@export_range(0, 100, 0.1, "or_greater") var jump_angle: float
