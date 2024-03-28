@tool
class_name Parryable
extends Node

## Испускается, когда снаряд был парирован.
signal parried

## Корневой узел снаряда.
@export var root_node: Node2D:
	set = set_root,
	get = get_root


## Проверяет наличие корневого узла.
func _ready() -> void:
	if !Engine.is_editor_hint():
		assert(root_node != null)


## Получает данные об атаке и разворачивает снаряд в направлении атаки.
func _hurt(attack_data: AttackData) -> void:
	if !Engine.is_editor_hint():
		root_node.look_at(root_node.position + attack_data.direction)


## Setter для поля [member root_node]. Не позволяет изменить корневой узел во
## время игры.
func set_root(value: Node2D) -> void:
	if !Engine.is_editor_hint():
		if root_node == null:
			root_node = value
		else:
			push_error("Попытка изменить корневой узел")
	else:
		root_node = value


## Getter для поля [member root_node].
func get_root() -> Node2D:
	return root_node


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "Parryable"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)
