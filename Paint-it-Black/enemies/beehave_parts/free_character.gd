class_name FreeCharacter
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	(blackboard.get_value("beehave_tree") as BeehaveTree).disable()
	actor.queue_free()
	return SUCCESS
