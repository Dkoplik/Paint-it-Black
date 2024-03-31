@tool
class_name PlayerMovement
extends BasicCharacterMovement
## Этот класс отвечает за движение игрока.
##
## Эта компонента содержит реализацию прыжка, скольжения по стенам и прыжка от
## стен для игрока. В качестве параметров используются данные из
## [PlayerMovementData].


func _init() -> void:
	_class_name = &"PlayerMovement"


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_movement_data = Utilities.check_resource(movement_data, &"PlayerMovementData", warnings)
	_has_character_body = Utilities.check_reference(character_body, &"CharacterBody2D", warnings)
	return _has_movement_data && _has_character_body


## Осуществляет обычный прыжок или прыжок от стены, если [member character_body]
## находится на стене.
func jump() -> void:
	if character_body.is_on_wall():
		_wall_jump()
	else:
		_standard_jump()


## Осуществляет обычный прыжок.
func _standard_jump() -> void:
	add_velocity(Vector2(0, -movement_data.jump_speed))


## Осуществляет прыжок от стены.
func _wall_jump() -> void:
	var wall_normal: Vector2 = character_body.get_wall_normal()
	var jump_velocity := Vector2(
		cos(deg_to_rad(90 - movement_data.jump_angle)) * movement_data.jump_speed,
		sin(deg_to_rad(-90 + movement_data.jump_angle)) * movement_data.jump_speed
	)
	jump_velocity.x *= wall_normal.x
	add_velocity(jump_velocity)


## Применяет к персонажу [member character_body] гравитацию с ускорением в
## зависимости от 2-х ситуаций: скольжение по стене или свободное падение.
func _apply_gravity(delta_time: float) -> void:
	# ToDo неплохо бы все обращения к скорости игрока заменить на add_velocity
	if not character_body.is_on_floor():
		if character_body.is_on_wall():
			character_body.velocity.y = _calculate_sliding_speed(delta_time)
		else:
			character_body.velocity.y = _calculate_fall_speed(delta_time)


## Вычисляет и возвращает текущую скорость скольжения персонажа
## [member character_body] для метода [method _apply_gravity].
func _calculate_sliding_speed(delta_time):
	var velocity_y: float = character_body.velocity.y
	velocity_y += movement_data.sliding_acceleration * delta_time
	if velocity_y < movement_data.max_sliding_speed:
		return velocity_y
	return movement_data.max_sliding_speed
