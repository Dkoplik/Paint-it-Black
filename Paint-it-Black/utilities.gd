@tool
extends Node


## Создаёт таймер на [param seconds] секунд.
func wait_for(seconds: float):
	await get_tree().create_timer(seconds).timeout


## Проверяет наличие ресурса в поданной переменной. Если ресурс
## [member resource]отсутствует, то возвращает false, в редакторе добавляет
## предупреждение, в игре кидает ошибку через [method push_error]. Иначе
## просто возвращает true.
static func check_resource(resource: Resource, warnings: PackedStringArray = []) -> bool:
	if resource == null:
		if Engine.is_editor_hint():
			warnings.append("No resource available")
			return false
		push_error("No resource available")
		return false
	return true


## Возвращает true, если у переданного узла [param node] название его класса
## или любого из его предков совпадает с указанной строкой [param name].
static func is_string_class(node: Node, name: String) -> bool:
	if (node.has_method("is_class_name")):
		return node.is_class_name(name)
	else:
		return node.is_class(name)


## Проверяет, имеется ли у узла [param parent_node] единственный дочерний узел 
## класса [param component_name]. Если истинно, то возвращает найденный узел,
## иначе возвращает null, в редакторе добавляет предупреждение, а в билде
## кидает ошибку через [method push_error].
static func check_single_component(parent_node: Node, component_name: String, warnings: PackedStringArray = []) -> Node:
	var children: Array
	for node in parent_node.get_children():
		if is_string_class(node, component_name):
			children.push_back(node)
	
	if children.size() > 1:
		if Engine.is_editor_hint():
			warnings.push_back("Обнаружено несколько компонент {component_name}")
		else:
			push_error("Обнаружено несколько компонент {component_name}")
		return null
	elif children.size() == 0:
		if Engine.is_editor_hint():
			warnings.push_back("Не найдена компонента {component_name}")
		else:
			push_error("Не найдена компонента {component_name}")
		return null
	else:
		return children[0]
