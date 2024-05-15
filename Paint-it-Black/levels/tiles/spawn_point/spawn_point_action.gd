class_name SpawnPointAction
extends CustomResource

## Действие успешно завершилось.
signal action_completed


func _init() -> void:
	_class_name = &"SpawnPointAction"


func do_action() -> bool:
	check_configuration()
	return false
