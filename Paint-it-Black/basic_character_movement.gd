extends Node
class_name BasicCharacterMovement
## Этот класс отвечает за минимальный набор движения персонажа.
##
## Эта компонента содержит реализацию обычного движения (ходьба или бег) и 
## падения персонажа. В качестве параметров используются данные из
## [BasicMovementData].

## Испускается, когда у персонажа отсутсвует какое-либо движение
signal started_idle
## Испускается, когда персонаж начал движение: ходьба или бег
signal started_walking
## Испускается, когда персонаж начал падать
signal started_falling

## Ресурс [BasicMovementData], необходимый для работы данной компоненты.
@export var movement_data: BasicMovementData
## Ссылка на [CharacterBody2D], который данная компонента будет двигать.
@export var character_body: CharacterBody2D


func _ready() -> void:
	# ToDo: проверка наличия movement_data и chracter_body. То есть, они должны
	# быть не null, иначе компонент не будет работать. По этому проверку
	# выполнять в assert, чтобы программа прерывалась.
	assert(movement_data != null)
	assert(character_body != null)


func _physics_process(delta) -> void:
	_gravity_and_slide(delta)
	character_body.move_and_slide()
	# ToDo: Тут тупо разместить приватные функции с нужными проверками и
	# изменениями. Проблема в том, что эта виртуальная функция будет
	# перезаписана при наследовании, из-за чего весь нужный функционал должен
	# быть в отдельных приватных функциях.
	pass


## Задаёт ходьбу или бег (зависит от скорости в [BasicMovementData]) в заданном
## направлении [param direction].x, при этом составляющая [param direction].y
## полностью игнорируется. Скорость движения, заданой этой функцией, не может
## превысить значение [member BasicMovementData.max_movement_speed], а
## увеличение или уменьшение текущей скорости персонажа происходит с ускорением
## [member BasicMovementData.movement_acceleration].
func move(direction: Vector2) -> void:
	# ToDo. Здесь просиходит только прибавление к character_body.velocity
	# скорости по горизонтали. А ещё, соответсвенно, обработка горизонтальной
	# скорости с использование ускорения как в обычной физике. Никакие сигналы
	# тут испускать не стоит, эта функция отвечает чисто за движение по запросу.
	if direction.x:
		character_body.velocity.x = _speed(direction.x)
	else: 
		character_body.velocity.x = _stop()


## вычисляет, и ограничивает скорость
## direction - направление движения по x (1/-1)
func _speed(direction):
	var velocity = character_body.velocity.x # текущая скорость персонажа по х
	velocity += movement_data.movement_acceleration*direction
	if(abs(velocity) > movement_data.max_movement_speed):
		return movement_data.max_movement_speed * direction
	else: 
		return velocity

## отвечает за плавную остановку
func _stop():
	var velocity = character_body.velocity.x
	if(velocity < 0):
		if(velocity + movement_data.movement_acceleration >=0):
			return 0
		else: 
			return velocity + movement_data.movement_acceleration
	if(velocity > 0):
		if(velocity - movement_data.movement_acceleration <=0):	
			return 0
		else:
			return velocity - movement_data.movement_acceleration
	if(velocity == 0):
		return 0

## Создаёт гравитацию
func _gravity_and_slide(delta):
	if not character_body.is_on_floor():
		character_body.velocity.y += _fall_speed(movement_data.gravity * delta)

## Вычисляет скорость падения
func _fall_speed(speed):
	if speed<movement_data.max_fall_speed:
		return speed

## Добавляет к текущей скорости [member CharacterBody2D.velocity] заданный
## вектор скорости [param velocity]. Эта функция нужна для тех случаев, когда на
## движение персонажа влияют какие-то внешние явления, по типу атаки игрока или
## откидывание при получении урона.
func add_velocity(velocity: Vector2) -> void:
	# ToDo. Просто к текущей скорости добавляет указанную в функции.
	character_body.velocity.x += velocity.x


## Приватный метод. Проверяет персонажа на отсутствие движения и испускает
## сигнал [signal started_idle].
func _check_idle() -> void:
	if character_body.velocity:
		started_idle.emit()

## Приватный метод. Проверяет персонажа на наличие движения по оси x и испускает
## при сигнал [signal started_walking].
func _check_walking() -> void:
	if character_body.velocity.x:
		started_walking.emit()

## Приватный метод. Проверяет персонажа на падениe и испускает сигнал
## [signal started_falling].
func _check_falling() -> void:
	if character_body.velocity.y:
		started_falling.emit()
