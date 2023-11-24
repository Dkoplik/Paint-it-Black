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

## Флаг прыжка. 
var _is_started_jump: bool
## Флаг скольжения.
var _is_started_sliding: bool


func _ready() -> void:
	# ToDo: проверка наличия movement_data и chracter_body. То есть, они должны
	# быть не null, иначе компонент не будет работать. По этому проверку
	# выполнять в assert, чтобы программа прерывалась.
	# Более того, нужно проверить, что movement_data не просто
	# BasicMovementData, а именно PlayerMovementData (проверить через is).
	assert(movement_data != null and character_body != null)
	## проверка на то, что мы используем ресурсы игрока, а не что-то иное.
	assert(movement_data is PlayerMovementData)


func _process(delta):
	_current_delta = delta
	_gravity_and_slide(delta)
	character_body.move_and_slide()
	_check_falling()
	_check_walking()
	_check_idle()
	_check_sliding()


## Осуществляет прыжок игрока, причём как обычный, так и от стен, и испускает
## сигнал [signal started_jump]. Если игрок не находится ни на полу, ни на
## стене, то метод ничего не делает. Если игрок на полу, то он получает
## начальную вертикальную скорость [member PlayerMovementData.jump_speed],
## если на стене, то учитывается ещё параметр
## [member PlayerMovementData.jump_angle].
func jump() -> void:
	if character_body.is_on_floor(): # простой прыжок
		character_body.velocity.y -= movement_data.jump_speed
	if character_body.is_on_wall(): # прыжок от стены
		var wall_position = character_body.get_wall_normal()
		var jump_direction =\
		Vector2(cos(deg_to_rad(90 - movement_data.jump_angle)) * movement_data.jump_speed,
		sin(deg_to_rad(-90 + movement_data.jump_angle)) * movement_data.jump_speed) #направление прыжка
		if wall_position.x>0: # стена слева
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
			character_body.velocity.y += movement_data.sliding_acceleration * delta
		else:
			character_body.velocity.y = _fall_speed(delta)

## Приватный метод. Проверяет персонажа на скольжение и испускает сигнал
## [signal started_sliding].
func _check_sliding():
	if character_body.is_on_wall_only() and not _is_started_sliding:
		started_sliding.emit()
		_is_started_sliding = true
	if !character_body.is_on_wall_only() and _is_started_sliding:
		_is_started_sliding = false

func _check_jumping():
	pass
	
	

