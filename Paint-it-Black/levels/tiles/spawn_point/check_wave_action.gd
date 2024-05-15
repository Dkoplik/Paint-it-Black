class_name CheckWaveAction
extends SpawnPointAction


## Какой номер волны должен быть, чтобы пройти дальше?
@export var wave_number: int = 0


func _init() -> void:
	_class_name = &"CheckWaveAction"


func do_action() -> bool:
	return GameManager.wave_number >= wave_number
