class_name GameManagerResource
extends CustomResource

## Замедление времени для hit stop.
@export_range(0, 0.1, 0.01) var time_scale: float
## Длительность hit stop при получении урона.
@export_range(0, 0.5, 0.01, "or_greater") var hurt_stop_duration: float
## Длительность hit stop при нанесении урона.
@export_range(0, 0.5, 0.01, "or_greater") var hit_stop_duration: float
## Длительность hit stop при парировании.
@export_range(0, 0.5, 0.01, "or_greater") var parry_stop_duration: float


func _init() -> void:
	_class_name = &"GameManagerResource"
