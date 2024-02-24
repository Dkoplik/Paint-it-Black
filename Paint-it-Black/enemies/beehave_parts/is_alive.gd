class_name IsAlive
extends ConditionLeaf

var hp_component: HP


func before_run(actor: Node, blackboard: Blackboard) -> void:
	hp_component = actor.get_hp_component()


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if (hp_component.get_current_hp() > 0):
		return SUCCESS
	return FAILURE
