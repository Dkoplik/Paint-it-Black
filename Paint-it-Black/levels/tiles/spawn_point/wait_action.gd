class_name WaitAction
extends SpawnPointAction

@export var wait_time := 1.0


func _init() -> void:
	_class_name = &"WaitAction"


func do_action() -> bool:
	await AutoloadUtilities.wait_for(wait_time)

	action_completed.emit()
	return true
