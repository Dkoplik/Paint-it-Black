class_name PlayerIncomingAttack
extends BasicIncomingAttack
## Ресурс атаки, создаваемой игроком.

## Направление атаки
@export var direction: Vector2:
	set = set_direction,
	get = get_direction


func _init() -> void:
	_class_name = &"PlayerIncomingAttack"


## Setter для поля [member direction].
func set_direction(value: Vector2) -> void:
	direction = value.normalized()


## Getter для поля [member direction].
func get_direction() -> Vector2:
	return direction
