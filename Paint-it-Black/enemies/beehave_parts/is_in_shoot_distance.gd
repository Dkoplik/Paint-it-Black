class_name IsInShootDistance
extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target: Node2D = blackboard.get_value("target")
	if target == null:
		push_warning("Отсутствует target для узла дерева поведения")
		return FAILURE

	var shoot_distance: float = blackboard.get_value("shoot_distance")
	if _distance_to(actor, target) <= shoot_distance:
		return SUCCESS
	return FAILURE


func _distance_to(actor: Node, target: Node2D) -> float:
	var actor_pos: Vector2 = (actor as Node2D).position
	var target_pos: Vector2 = target.position
	return (actor_pos - target_pos).length()
