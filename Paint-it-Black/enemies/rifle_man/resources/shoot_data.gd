class_name ShootData
extends CustomResource
## Этот класс отвечает за хранение параметров для стрельбы.

## Снаряд, используемый при стрельбе.
@export var projectile: PackedScene
## Время между выстрелами.
@export_range(0.0, 5.0, 0.1, "or_greater") var cooldown: float
## Угол разброса снарядов, в градусах.
@export_range(0.0, 10.0, 0.01) var spread_angle: float
## Максимальное расстояние стрельбы.
@export_range(0.0, 1000.0, 0.1, "or_greater") var shoot_range: float


func _init() -> void:
	_class_name = &"ShootData"
