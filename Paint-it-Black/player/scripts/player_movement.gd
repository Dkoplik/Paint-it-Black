extends BasicCharacterMovement
class_name PlayerMovement
## Этот класс отвечает за движение игрока.
##
## Эта компонента содержит реализацию прыжка, скольжения по стенам и прыжка от
## стен для игрока. В качестве параметров используются данные из
## [PlayerMovementData].

## Испускается, когда игрок совершил прыжок.
signal started_jump
## Испускается, когда игрок начал скользить по стене.
signal started_sliding

## Флаг прыжка. Устанавливается на true в момент прыжка, от стены/от пола. 
var _is_started_jump: bool
## Флаг скольжения. Устанавливается на true в момент начала скольжения по стене.
var _is_started_sliding: bool


func _ready() -> void:
	assert(movement_data != null)
	assert(character_body != null)
	# Проверка на то, что мы используем ресурсы игрока, а не что-то иное.
	assert(movement_data is PlayerMovementData)


func _process(delta):
	_current_delta = delta
	_gravity_and_slide(delta)
	character_body.move_and_slide()
	_check_falling()
	_check_walking()
	_check_idle()
	_check_sliding()
	_check_jumping()

## Осуществляет прыжок игрока, причём как обычный, так и от стен, и испускает
## сигнал [signal started_jump]. Если игрок не находится ни на полу, ни на
## стене, то метод ничего не делает. Если игрок на полу, то он получает
## начальную вертикальную скорость [member PlayerMovementData.jump_speed],
## если на стене, то учитывается ещё параметр
## [member PlayerMovementData.jump_angle].
func jump() -> void:
	if character_body.is_on_floor(): # простой прыжок
		_is_started_jump = true
		character_body.velocity.y -= movement_data.jump_speed
	elif character_body.is_on_wall(): # прыжок от стены
		_is_started_jump = true
		var wall_position = character_body.get_wall_normal()
		var jump_direction =\
		Vector2(cos(deg_to_rad(90 - movement_data.jump_angle)) * movement_data.jump_speed,
		sin(deg_to_rad(-90 + movement_data.jump_angle)) * movement_data.jump_speed) #направление прыжка
		if wall_position.x > 0: # стена слева
			character_body.velocity += jump_direction
		else:
			jump_direction.x *= -1
			character_body.velocity += jump_direction

## Отвечает за создание гравитации и скольжение по стенам.
## Создаёт гравитацию.
## Добавляет к текущей скорости [member CharacterBody2D.velocity.y] 
## вычисленный параметр из функции _fall_speed().
## Создаёт скольжение.
## Добавляет к текущей скорости [member CharacterBody2D.velocity.y] 
## параметр movement_data.sliding_acceleration * delta
func _gravity_and_slide(delta: float) -> void:
	if not character_body.is_on_floor():
		if character_body.is_on_wall():
			character_body.velocity.y = _sliding_speed(delta)
			#print(movement_data.sliding_acceleration * delta)
		else:
			character_body.velocity.y = _fall_speed(delta)

## Приватный метод. Проверяет персонажа на скольжение и испускает сигнал
## [signal started_sliding].
func _check_sliding():
	if character_body.is_on_wall_only() and not _is_started_sliding:
		started_sliding.emit()
		_is_started_sliding = true
	elif !character_body.is_on_wall_only() and _is_started_sliding:
		_is_started_sliding = false

## Приватный метод. Проверяет персонажа на прыжок и испускает сигнал
## [signal started_jumping].
func _check_jumping():
	if _is_started_jump and not character_body.is_on_floor():
		started_jump.emit()
		_is_started_jump = false
	
func _sliding_speed(delta):
	var speed = character_body.velocity.y
	speed += movement_data.sliding_acceleration * delta
	if speed < movement_data.max_sliding_speed:
		return speed
	else:
		return movement_data.max_sliding_speed
			
 
