class_name ShootData
extends CustomResource
## Этот класс отвечает за хранение параметров для стрельбы.

## Снаряд, используемый при стрельбе.
@export var projectile: PackedScene
## Время между выстрелами.
@export_range(0, 5, 0.1, "or_greater") var cooldown: float
## Угол разброса снарядов, в градусах.
@export_range(0, 10, 0.01) var spread_angle: float


func _init() -> void:
	_class_name = &"ShootData"
