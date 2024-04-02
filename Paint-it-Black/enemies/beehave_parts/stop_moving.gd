class_name StopMoving
extends ActionLeaf

var character_movement: BasicCharacterMovement


func before_run(actor: Node, blackboard: Blackboard) -> void:
	character_movement = blackboard.get_value("movement_component")


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if character_movement == null:
		return FAILURE

	character_movement.decelerate_to_stop()
	return SUCCESS
