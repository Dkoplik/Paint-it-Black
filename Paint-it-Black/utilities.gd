@tool
class_name Utilities
## Этот класс содержит полезные функции для глобального использования.


## Создаёт таймер на [param seconds] секунд.
static func wait_for(seconds: float):
	pass # ToDo: создание таймера на seconds секунд и возврат через yield


## Проверяет наличие ресурса в поданной переменной. Если ресурс
## [member resource]отсутствует, то возвращает false, в редакторе добавляет
## предупреждение, в игре кидает ошибку через [method push_error]. Иначе
## просто возвращает true.
static func check_resource(resource: Resource, warnings: PackedStringArray = []) -> bool:
	# ToDo: сделать проверку наличия ресурса. Если ресурс отсутствует и скрипт
	# работает в редакторе, то добавить строку с предупреждением в warnings,
	# если скрипт работает в игре, то кинуть ошибку через push_error().
	return false
