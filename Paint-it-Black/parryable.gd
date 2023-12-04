@tool
extends Node
class_name Parryable

## Испускается, когда снаряд был парирован.
signal parried

## Корневой узел снаряда.
@export var root_node: Node2D:
	set = set_root, get = get_root


## Проверяет наличие корневого узла.
func _ready() -> void:
	if !Engine.is_editor_hint():
		pass
		# ToDo: проверить наличие корневого узла. Если он отсутствует, то
		# прервать программу через assert.


## Получает данные об атаке и разворачивает снаряд в направлении атаки.
func _hurt(attack_data: AttackData) -> void:
	if !Engine.is_editor_hint():
		# ToDo: из attack_data берёт параметр direction,
		# и в это направление разворачивает root_node.
		pass


## Setter для поля [member root_node]. Не позволяет изменить корневой узел во
## время игры.
func set_root(value: Node2D) -> void:
	if !Engine.is_editor_hint():
		# ToDo: если root_node ещё Null, то присвоить новое значение, иначе не
		# менять значение переменной и бросить ошибку через push_error() о
		# попытке изменить корневой узел.
		pass
	else:
		root_node = value


## Getter для поля [member root_node].
func get_root() -> Node2D:
	return null # ToDo просто вернуть root_node
