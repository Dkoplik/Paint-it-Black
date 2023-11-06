extends BasicMovementData
class_name PlayerMovementData

## Параметры прыжка
@export_group("Jumping")
## Начальная скорость прыжка
@export_range(0, 100, 0.1, "or_greater") var jump_speed: float
## Угол прыжка при скольжении
@export_range(0, 100, 0.1, "or_greater") var jump_angle: float

## Параметры скольжения по стенам
@export_group("Sliding")
## Ускорение скольжения (вместо гравитации)
@export_range(0, 100, 0.1, "or_greater") var sliding_acceleration: float
## Максимальная развиваемая скорость скольжения
@export_range(0, 100, 0.1, "or_greater") var max_sliding_speed: float
