@tool
extends Node


## Создаёт таймер на [param seconds] секунд.
func wait_for(seconds: float):
	await get_tree().create_timer(seconds).timeout


## Проверяет наличие ресурса в поданной переменной. Если ресурс
## [member resource]отсутствует, то возвращает false, в редакторе добавляет
## предупреждение, в игре кидает ошибку через [method push_error]. Иначе
## просто возвращает true.
static func check_resource(resource: Resource, resource_name := "", warnings: PackedStringArray = []) -> bool:
	if resource == null:
		if Engine.is_editor_hint():
			warnings.append("Не обнаружен ресурс %s" % resource_name)
		else:
			push_error("Не обнаружен ресурс %s" % resource_name)
		return false
	return true


## Универсальная функция для нахождения имени класса [param object], будь то
## нативный класс или кастомный.
static func get_class_name(object: Object) -> StringName:
	if (object.has_method("get_class_name")):
		return object.get_class_name()
	return object.get_class()


## Универсальная функция для сравнения строки [param string_name] с названием
## класса объекта [param object]
static func is_class_name(object: Object, string_name: StringName) -> bool:
	if object.has_method("is_class_name"):
		return object.is_class_name(string_name)
	return object.is_class(string_name)


## Проверяет, имеется ли у узла [param parent_node] единственный дочерний узел
## класса [param component_class]. Если истинно, то возвращает найденный узел,
## иначе возвращает null, в редакторе добавляет предупреждение, а в билде
## кидает ошибку через [method push_error].
static func check_single_component(
	parent_node: Node, component_class: StringName, warnings: PackedStringArray = []
) -> Node:
	var children: Array
	for node in parent_node.get_children():
		if is_class_name(node, component_class):
			children.push_back(node)

	if children.size() > 1:
		if Engine.is_editor_hint():
			warnings.push_back("Обнаружено несколько компонент %s" % component_class)
		else:
			push_error("Обнаружено несколько компонент %s" % component_class)
		return null
	if children.size() == 0:
		if Engine.is_editor_hint():
			warnings.push_back("Не найдена компонента %s" % component_class)
		else:
			push_error("Не найдена компонента %s" % component_class)
		return null
	return children[0]


## Проверяет, содержится ли в [param object] ссылка на объект. Если object =
## null, то в редакторе добавляет предупреждение, а в билде кидает ошибку
## череp [method push_error].
static func check_reference(object: Object, object_name := "объект", warnings: PackedStringArray = []) -> bool:
	if object == null:
		if Engine.is_editor_hint():
			warnings.append("Ссылка на %s оказалась пустой" % object_name)
		else:
			push_error("Ссылка на %s оказалась пустой" % object_name)
		return false
	return true
