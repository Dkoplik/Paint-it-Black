class_name ShootTarget
extends ActionLeaf

var target: CharacterBody2D
var shoot_component: ShootComponent

func before_run(actor: Node, blackboard: Blackboard) -> void:
	target = blackboard.get_value("target")
	shoot_component = blackboard.get_value("shoot_component")


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if target == null or shoot_component == null:
		return FAILURE

	var shooted: bool = shoot_component.shoot_in_direction(_direction_to(actor, target))
	if shooted:
		return SUCCESS
	return FAILURE


func _direction_to(actor: Node, target: Node2D) -> Vector2:
	return (target.position - (actor as Node2D).position)
