class_name MoveToTaget
extends ActionLeaf

var target: CharacterBody2D
var character_movement: BasicCharacterMovement


func before_run(actor: Node, blackboard: Blackboard) -> void:
	target = blackboard.get_value("target")
	character_movement = blackboard.get_value("movement_component")


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if target == null or character_movement == null:
		return FAILURE

	character_movement.move_in_direction(_direction_to(actor, target))
	return SUCCESS


func _direction_to(actor: Node, target: Node2D) -> Vector2:
	return (target.position - (actor as Node2D).position)
