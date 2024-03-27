class_name PlayerAttackData
extends CustomResource
## Этот ресурс отвечает за параметры атаки игрока.

## Количество наносимого урона.
@export_range(0, 20, 1, "or_greater") var damage: int
## Длительность атаки. Задаёт длительность анимации для [HitBox].
@export_range(0, 2, 0.001, "or_greater") var duration: float
## Время между атаками.
@export_range(0, 2, 0.001, "or_greater") var cooldown: float
## Величина импульса / толчка во время атаки при наличии опоры.
@export_range(0, 200, 0.01, "or_greater") var strong_impulse: float
## Величина импульса / толчка во время атаки в воздухе.
@export_range(0, 200, 0.01, "or_greater") var weak_impulse: float


func _init() -> void:
	_class_name = &"PlayerAttackData"
