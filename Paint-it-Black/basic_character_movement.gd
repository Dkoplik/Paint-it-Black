extends Node
class_name BasicCharacterMovement
## Этот класс отвечает за минимальный набор движения персонажа.
##
## Эта компонента содержит реализацию обычного движения (ходьба или бег) и 
## падения персонажа. В качестве параметров используются данные из
## [BasicMovementData].

## Испускается, когда у персонажа отсутсвует какое-либо движение.
signal started_idle
## Испускается, когда персонаж начал движение: ходьба или бег.
signal started_walking
## Испускается, когда персонаж начал падать.
signal started_falling

## Флаг персонажа стоящего на месте.
var _is_idle: bool
## Флаг идущего персонажа.
var _is_walking: bool
## Флаг падающего персонажа.
var _is_falling: bool

## Ресурс [BasicMovementData], необходимый для работы данной компоненты.
@export var movement_data: BasicMovementData
## Ссылка на [CharacterBody2D], который данная компонента будет двигать.
@export var character_body: CharacterBody2D
## Переменная, которую будем использовать вместо дельты, за пределами
## функции _physics_process
var _current_delta:float


func _ready() -> void:
	assert(movement_data != null, "Отсутствует movement_data")
	assert(character_body != null, "Отсутствует character_body")


func _physics_process(delta) -> void:
	_current_delta = delta
	_gravity_and_slide(delta)
	character_body.move_and_slide()
	_check_falling()
	_check_walking()
	_check_idle()


## Задаёт ходьбу или бег (зависит от скорости в [BasicMovementData]) в заданном
## направлении [param direction].x, при этом составляющая [param direction].y
## полностью игнорируется. Скорость движения, заданой этой функцией, не может
## превысить значение [member BasicMovementData.max_movement_speed], а
## увеличение или уменьшение текущей скорости персонажа происходит с ускорением
## [member BasicMovementData.movement_acceleration].
func move(direction: Vector2) -> void:
	if direction.x:
		character_body.velocity.x = _speed(direction)
	else: 
		character_body.velocity.x = _stop()


## вычисляет, и ограничивает скорость
## direction - вектор движения персонажа (-1/1)
func _speed(direction: Vector2) -> float:
	var velocity = character_body.velocity.x # текущая скорость персонажа по х
	velocity += movement_data.movement_acceleration * direction.x * _current_delta
	if(abs(velocity) > movement_data.max_movement_speed):
		return movement_data.max_movement_speed * direction.x
	else: 
		return velocity


## Отвечает за плавную остановку.
func _stop() -> float:
	var velocity: float = character_body.velocity.x
	if(velocity < 0):
		if(velocity + movement_data.movement_acceleration >= 0):
			return 0
		else: 
			return velocity + movement_data.movement_acceleration * _current_delta
	if(velocity > 0):
		if(velocity - movement_data.movement_acceleration <= 0):	
			return 0
		else:
			return velocity - movement_data.movement_acceleration * _current_delta
	return 0


## Создаёт гравитацию.
## Добавляет к текущей скорости [member CharacterBody2D.velocity.y] 
## вычисленный параметр из функции _fall_speed().
func _gravity_and_slide(delta: float) -> void:
	if not character_body.is_on_floor():
		character_body.velocity.y = _fall_speed(delta)


## Вычисляет скорость падения.
func _fall_speed(delta: float) -> float:
	var speed = character_body.velocity.y
	speed += (movement_data.gravity * delta)
	if speed < movement_data.max_fall_speed:
		return speed
	else: 
		return movement_data.max_fall_speed


## Добавляет к текущей скорости [member CharacterBody2D.velocity] заданный
## вектор скорости [param velocity]. Эта функция нужна для тех случаев, когда на
## движение персонажа влияют какие-то внешние явления, по типу атаки игрока или
## откидывание при получении урона.
func add_velocity(velocity: Vector2) -> void:
	character_body.velocity += velocity


## Приватный метод. Проверяет персонажа на отсутствие движения и испускает
## сигнал [signal started_idle].
func _check_idle():
	if (character_body.velocity == Vector2.ZERO) and not _is_idle and not _is_walking:
		started_idle.emit()
		_is_idle = true
	if !((character_body.velocity.x == 0) and (character_body.velocity.y == 0)) and _is_idle:
		_is_idle = false


## Приватный метод. Проверяет персонажа на наличие движения по оси x и испускает
## при сигнал [signal started_walking].
func _check_walking():
	if character_body.velocity.x and not _is_walking and not _is_falling:
		started_walking.emit()
		_is_walking = true
	if !character_body.velocity.x and _is_walking:
		_is_walking = false


## Приватный метод. Проверяет персонажа на падениe и испускает сигнал
## [signal started_falling].
func _check_falling():
	if character_body.velocity.y and not _is_falling:
		started_falling.emit()
		_is_falling = true
	if !character_body.velocity.y and _is_falling:
		_is_falling = false
