class_name AttackData
extends Resource
## Этот класс отвечает за базовые параметры атаки.

## Количество наносимого урона.
@export_range(0, 20, 1, "or_greater") var damage: int
