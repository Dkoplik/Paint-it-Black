@tool
class_name Utilities
extends Node


## Создаёт таймер на [param seconds] секунд.
func wait_for(seconds: float):
	await get_tree().create_timer(seconds).timeout


# ToDo check_resource и check_reference почти дублируют друг друга.
## Проверяет наличие ресурса в поданной переменной. Если ресурс
## [member resource]отсутствует, то возвращает false, в редакторе добавляет
## предупреждение, в игре кидает ошибку через [method push_error]. Иначе
## просто возвращает true.
static func check_resource(
	resource: Resource, class_name_str: StringName, warnings: PackedStringArray = []
) -> bool:
	# Примечание: не нашёл способа избавиться от параметра class_name_str, так
	# как при отсутствии ресурса его переменная равна null, а название класса
	# для null вроде невозможно определить.
	if resource == null:
		if Engine.is_editor_hint():
			warnings.append("Не обнаружен ресурс %s" % class_name_str)
		else:
			push_error("Не обнаружен ресурс %s" % class_name_str)
		return false
# Почему-то адекватно не работает
#	if not is_class_name(resource, class_name_str):
#		if Engine.is_editor_hint():
#			warnings.append(
#				"Обнаружен ресурс типа %s вместо %s" % [get_class_name(resource), class_name_str]
#			)
#		else:
#			push_error(
#				"Обнаружен ресурс типа %s вместо %s" % [get_class_name(resource), class_name_str]
#			)
#		return false
	return true


## Проверяет, содержится ли в [param object] ссылка на объект. Если object =
## null, то в редакторе добавляет предупреждение, а в билде кидает ошибку
## череp [method push_error].
static func check_reference(
	object: Object, class_name_str: StringName, warnings: PackedStringArray = []
) -> bool:
	# Примечание: не нашёл способа избавиться от параметра class_name_str, так
	# как при отсутствии ресурса его переменная равна null, а название класса
	# для null вроде невозможно определить.
	if object == null:
		if Engine.is_editor_hint():
			warnings.append("Ссылка на %s оказалась пустой" % class_name_str)
		else:
			push_error("Ссылка на %s оказалась пустой" % class_name_str)
		return false
# Почему-то адекватно не работает
#	if not is_class_name(object, class_name_str):
#		if Engine.is_editor_hint():
#			warnings.append(
#				"Обнаружен объект типа %s вместо %s" % [get_class_name(object), class_name_str]
#			)
#		else:
#			push_error(
#				"Обнаружен объект типа %s вместо %s" % [get_class_name(object), class_name_str]
#			)
#		return false
	return true


## Универсальная функция для нахождения имени класса [param object], будь то
## нативный класс или кастомный.
static func get_class_name(object: Object) -> StringName:
	if object.has_method("get_class_name"):
		return object.get_class_name()
	return object.get_class()


## Универсальная функция для сравнения строки [param string_name] с названием
## класса объекта [param object]
static func is_class_name(object: Object, string_name: StringName) -> bool:
	return get_class_name(object) == string_name


## Проверяет, имеется ли у узла [param parent_node] единственный дочерний узел
## класса [param component_class]. Если истинно, то возвращает найденный узел,
## иначе возвращает null, в редакторе добавляет предупреждение, а в билде
## кидает ошибку через [method push_error].
static func check_single_component(
	parent_node: Node, component_class: StringName, warnings: PackedStringArray = []
) -> Node:
	var children: Array = []
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


## Возвращает расстояние между двумя указанными узлами.
static func distance_between(from: Node2D, to: Node2D) -> float:
	return from.position.distance_to(to.position)
