class_name PlayerMovement
extends BasicCharacterMovement
## Этот класс отвечает за движение игрока.
##
## Эта компонента содержит реализацию прыжка, скольжения по стенам и прыжка от
## стен для игрока. В качестве параметров используются данные из
## [PlayerMovementData].


func _init() -> void:
	_class_name = &"PlayerMovement"


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	_has_movement_data = Utilities.check_resource(movement_data, &"PlayerMovementData", warnings)
	_has_character_body = Utilities.check_reference(character_body, &"CharacterBody2D", warnings)

	return warnings


## Осуществляет прыжок игрока от пола или от стены, в зависимости от состояния
## игрока [member character_body].
func jump() -> void:
	# ToDo неплохо бы простой прыжок и прыжок от стены разбить на 2 отдельные
	# приватные функции
	if character_body.is_on_floor():  # простой прыжок
		character_body.velocity.y -= movement_data.jump_speed
	elif character_body.is_on_wall():  # прыжок от стены
		var wall_position = character_body.get_wall_normal()
		var jump_direction = Vector2(
			cos(deg_to_rad(90 - movement_data.jump_angle)) * movement_data.jump_speed,
			sin(deg_to_rad(-90 + movement_data.jump_angle)) * movement_data.jump_speed
		)  #направление прыжка
		if wall_position.x > 0:  # стена слева
			character_body.velocity += jump_direction
		else:
			jump_direction.x *= -1
			character_body.velocity += jump_direction


## Применяет к персонажу [member character_body] гравитацию с ускорением в
## зависимости от 2-х ситуаций: скольжение по стене или свободное падение.
func _apply_gravity(delta_time: float) -> void:
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
