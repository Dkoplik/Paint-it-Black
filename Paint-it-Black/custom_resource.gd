class_name CustomResource
extends Resource
## Родительский класс для всех кастомных ресурсов. Предоставляет методы,
## необходимые для любого ресурса.
##
## В основном существование этого класса связано с ограничентями GDScript,
## например, для собственных классов невозможно получить их название: функция
## [method Object.get_class] возвращает только нативные классы.

## Строковое представление название класса. Используется для методов,
## связанных с использованием названия кастомного класса, например
## [method get_class_name].
var _class_name: StringName = &"CustomResource":
	get = get_class_name
# Единственное, я не нашёл способа проверить валидность переменной
# _class_name во время запуска. То есть, во время наследования можно забыть
# про необходимость задать новое значение для _class_name и никакой ошибки не
# возникнет, из-за чего дочерний кастомный класс будет иметь название
# родительского.


## Возвращает название класса в виде уникальной строки [StringName].
func get_class_name() -> StringName:
	return _class_name


## Возвращает true, если указанная строка [param string_name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false.
func is_class_name(string_name: StringName) -> bool:
	return (string_name == _class_name) or self.is_class(string_name)


## Проверка конфигурации узла, выполняется как в редакторе, так и в игре.
func check_configuration(_warnings: PackedStringArray = []) -> bool:
	push_warning("check_configuration не переопределён")
	return false
