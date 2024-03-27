class_name BasicIncomingAttack
extends CustomResource
## Базовый ресурс, отвечающий за передачу параметров атаки из hitbox в hurtbox.
##
## Этот ресурс содержит только количество наносимого урона, поэтому более
## конкретные типы атак должны наследоваться от этого класса.

## Количество наносимого урона.
var damage: int:
	get = get_damage,
	set = set_damage


func _init() -> void:
	_class_name = &"IncomingAttack"


## Getter для поля [member damage].
func get_damage() -> int:
	return damage


## Setter для поля [member damage]. При попытке присвоить отрицательный урон
## изменение значения не произойдёт и будет выброшена ошибка через
## [method @GlobalScope.push_error].
func set_damage(value: int) -> void:
	if value < 0:
		push_error("Попытка присвоить отрицательный урон в %s" % _class_name)
		return
	damage = value
