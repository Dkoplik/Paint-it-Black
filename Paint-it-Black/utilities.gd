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
