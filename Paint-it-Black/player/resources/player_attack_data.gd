@tool
extends AttackData
class_name PlayerAttackData
## Этот ресурс отвечает за параметры атаки игрока.


## Длительность атаки. Задаёт длительность анимации для [HitBox].
@export_range(0, 2, 0.001, "or_greater") var duration: float
## Время между атаками.
@export_range(0, 2, 0.001, "or_greater") var cooldown: float
## Величина импульса / толчка во время атаки при наличии опоры.
@export_range(0, 200, 0.01, "or_greater") var grounded_impulse: float
## Величина импульса / толчка во время атаки в воздухе.
@export_range(0, 200, 0.01, "or_greater") var in_air_impulse: float
