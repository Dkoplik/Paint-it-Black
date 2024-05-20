@tool
class_name BasicCharacterMovement
extends CustomNode
## Этот класс отвечает за минимальный набор методов движения персонажа.
##
## Эта компонента содержит реализацию движения влево/вправо и падения персонажа.
## В качестве параметров используются данные из [BasicMovementData].

## Персонаж смотрит направо
signal character_look_right
## Персонаж смотрит налево
signal character_look_left

## Номер слоя физики для платформ.
const PLATFORM_PHYSICS_LAYER := 5

## Ресурс [BasicMovementData], необходим для работы данной компоненты.
@export var movement_data: BasicMovementData:
	set = set_movement_data
## Ссылка на [CharacterBody2D], который данная компонента будет двигать.
@export var character_body: CharacterBody2D:
	set = set_character_body

## Флаг наличия ресурса в переменной [member movement_data].
var _has_movement_data := false
## Флаг наличия ссылки на узел в переменной [member _has_character_body].
var _has_character_body := false


func _init() -> void:
	# Объявление названия кастомного класса (см. класс CustomNode).
	_class_name = &"BasicCharacterMovement"


func _physics_process(delta) -> void:
	if Engine.is_editor_hint():
		return
	if not _has_character_body:
		# Спам в консоль, пока хз как лучше сделать
		push_error("Невозможно осуществить move_and_slide() без character_body")
		return

	_apply_gravity(delta)
	character_body.move_and_slide()
	_crop_speed()


func turn_on_platform_collision() -> void:
	character_body.set_collision_mask_value(PLATFORM_PHYSICS_LAYER, true)


func turn_off_platform_collision() -> void:
	character_body.set_collision_mask_value(PLATFORM_PHYSICS_LAYER, false)


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_movement_data = Utilities.check_resource(movement_data, &"BasicMovementData", warnings)
	_has_character_body = Utilities.check_reference(character_body, &"CharacterBody2D", warnings)
	return _has_movement_data && _has_character_body


## Setter для поля [member movement_data]. Обновляет ошибки конфигурации.
func set_movement_data(value: BasicMovementData) -> void:
	movement_data = value
	update_configuration_warnings()


## Setter для поля [member character_body]. Обновляет ошибки конфигурации.
func set_character_body(value: CharacterBody2D) -> void:
	character_body = value
	update_configuration_warnings()


## Осуществляет движение персонажа [member character_body] в заданном
## направлении [param direction.x]. Скорость движения, заданная этой функцией,
## не может превысить значение [member BasicMovementData.max_movement_speed], а
## изменение скорости персонажа происходит с ускорением
## [member BasicMovementData.movement_acceleration].
func move_in_direction(direction: Vector2) -> void:
	if not _has_character_body:
		push_error("Невозможно осуществить move_in_direction() без character_body")
		return
	if not _has_movement_data:
		push_error("Невозможно осуществить move_in_direction() без movement_data")
		return

	if direction.x > 0:
		character_look_right.emit()
	if direction.x < 0:
		character_look_left.emit()

	direction = direction.normalized()
	character_body.velocity.x = _calculate_speed_in_direction(direction)


func move_to_target(target: Node2D) -> void:
	var move_direction := (target.global_position - character_body.global_position).normalized()
	return move_in_direction(move_direction)


## Вычисляет и возвращает текущую скорость для осуществления движения в
## направлении [param direction] с ускорением
## [member BasicMovementData.movement_acceleration]. Скорость не может превысить
## значение [member BasicMovementData.max_movement_speed], однако не урезает эту
## скорость, если она была превышена каким-то другим способом.
func _calculate_speed_in_direction(direction: Vector2) -> float:
	var velocity_x: float = character_body.velocity.x
	var new_velocity_x: float = (
		velocity_x
		+ movement_data.movement_acceleration * direction.x * get_physics_process_delta_time()
	)

	# Если предел скорости превышен, то скорость не должна урезаться
	if abs(velocity_x) > movement_data.max_movement_speed:
		if abs(new_velocity_x) > abs(velocity_x):
			return velocity_x
		return new_velocity_x

	# Обычное изменение скорости
	if abs(new_velocity_x) > movement_data.max_movement_speed:
		return movement_data.max_movement_speed * direction.x
	return new_velocity_x


## Осуществляет остановку персонажа [member character_body] с ускорением
## торможения [member BasicMovementData.movement_acceleration]. Для полной
## остановки функцию необходимо вызвать до тех пор, пока не будет выполнено
## условие [member CharacterBody2D.velocity].x = 0.
func decelerate_to_stop() -> void:
	if not _has_character_body:
		push_error("Невозможно осуществить decelerate_to_stop() без character_body")
		return
	if not _has_movement_data:
		push_error("Невозможно осуществить decelerate_to_stop() без movement_data")
		return

	var decelerate_direction: float = -signf(character_body.velocity.x)
	var delta_time: float = get_physics_process_delta_time()
	var acceleration: float = movement_data.movement_acceleration

	if abs(character_body.velocity.x) < abs(acceleration * delta_time):
		character_body.velocity.x = 0.0
	else:
		character_body.velocity.x += decelerate_direction * acceleration * delta_time


## Применяет к персонажу [member character_body] гравитацию с ускорением падения
## [member BasicMovementData.gravity]. Скорость падения не может превысить
## значение [member BasicMovementData.max_fall_speed].
func _apply_gravity(delta_time: float) -> void:
	if not character_body.is_on_floor():
		character_body.velocity.y = _calculate_fall_speed(delta_time)


## Вычисляет и возвращает текущую скорость падения персонажа
## [member character_body] для метода [method _apply_gravity].
func _calculate_fall_speed(delta_time: float) -> float:
	var velocity_y: float = character_body.velocity.y
	velocity_y += movement_data.gravity * delta_time
	if velocity_y < movement_data.max_fall_speed:
		return velocity_y
	return movement_data.max_fall_speed


## Добавляет к текущей скорости [member CharacterBody2D.velocity] заданный
## вектор скорости [param velocity] и испускает новый сигнал направления игрока.
func add_character_velocity(velocity: Vector2) -> void:
	if not _has_character_body:
		push_error("Невозможно осуществить add_character_velocity() без character_body")
		return
	character_body.velocity += velocity
	_crop_speed()

	if velocity.x > 0:
		character_look_right.emit()
	if velocity.x < 0:
		character_look_left.emit()


## Устанавливает новую скорость [member CharacterBody2D.velocity] равную
## вектору скорости [param velocity] и испускает новый сигнал направления игрока.
func set_character_velocity(velocity: Vector2) -> void:
	if not _has_character_body:
		push_error("Невозможно осуществить set_character_velocity() без character_body")
		return
	character_body.velocity = velocity
	_crop_speed()

	if velocity.x > 0:
		character_look_right.emit()
	if velocity.x < 0:
		character_look_left.emit()


## Добавляет к текущей скорости [member CharacterBody2D.velocity] заданный
## вектор скорости [param velocity], но не меняет направление персонажа.
func add_velocity(velocity: Vector2) -> void:
	if not _has_character_body:
		push_error("Невозможно осуществить add_velocity() без character_body")
		return
	character_body.velocity += velocity
	_crop_speed()


## Устанавливает новую скорость [member CharacterBody2D.velocity] равную
## вектору скорости [param velocity], но не меняет направление персонажа.
func set_velocity(velocity: Vector2) -> void:
	if not _has_character_body:
		push_error("Невозможно осуществить set_velocity() без character_body")
		return
	character_body.velocity = velocity
	_crop_speed()


func _crop_speed() -> void:
	character_body.velocity.x = clampf(character_body.velocity.x, -movement_data.max_horizontal_speed, movement_data.max_horizontal_speed)
	character_body.velocity.y = clampf(character_body.velocity.y, -movement_data.max_up_speed, movement_data.max_fall_speed)
