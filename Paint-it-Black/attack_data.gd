extends Resource
class_name AttackData
## Этот класс отвечает за параметры атаки.
##
## В этом ресурсе содержатся все параметры атаки, которые [BasicHitBox]
## отправляет в [HurtBoxInterface] для обработки.

## Количество наносимого урона/
@export var damage: int
## Начальная скорость отбрасывания и её направление.
@export var knockback_velocity: Vector2
