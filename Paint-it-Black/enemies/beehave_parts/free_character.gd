class_name FreeCharacter
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.queue_free()
	return SUCCESS
