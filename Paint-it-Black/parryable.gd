@tool
class_name Parryable
extends CustomNode

## Испускается, когда снаряд был парирован.
signal parried

## Корневой узел снаряда.
@export var root_node: Node2D:
	set = set_root,
	get = get_root

## Есть ли ссылка на [member root_node].
var _has_root_node := false


func _init() -> void:
	_class_name = &"Parryable"


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_root_node = Utilities.check_reference(root_node, "Node2D", warnings)
	return _has_root_node


## Получает данные об атаке и разворачивает снаряд в направлении атаки.
func parry(attack_data: BasicIncomingAttack) -> void:
	if Engine.is_editor_hint():
		return
	# ToDo тут нет direction, надо либо добавить его в базовый класс, либо
	# заменить BasicIncomingAttack на что-то другое.
	root_node.look_at(root_node.position + attack_data.direction)
	parried.emit()


## Setter для поля [member root_node]. Не позволяет изменить корневой узел во
## время игры.
func set_root(value: Node2D) -> void:
	if !Engine.is_editor_hint() and _has_root_node:
		push_error("Попытка изменить корневой узел")
		return
	root_node = value
	update_configuration_warnings()


## Getter для поля [member root_node].
func get_root() -> Node2D:
	return root_node
