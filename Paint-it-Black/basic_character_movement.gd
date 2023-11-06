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
	pass


func _process(delta):
	# ToDo: реализовать
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
	pass


## Добавляет к текущей скорости [member CharacterBody2D.velocity] заданный
## вектор скорости [param velocity]. Эта функция нужна для тех случаев, когда на
## движение персонажа влияют какие-то внешние явления, по типу атаки игрока или
## откидывание при получении урона.
func add_velocity(velocity: Vector2) -> void:
	# ToDo. Просто к текущей скорости добавляет указанную в функции.
	pass


## Приватный метод. Проверяет персонажа на отсутствие движения и испускает
## сигнал [signal started_idle].
func _check_idle() -> void:
	# ToDo.
	pass


## Приватный метод. Проверяет персонажа на наличие движения по оси x и испускает
## при сигнал [signal started_walking].
func _check_walking() -> void:
	# ToDo.
	pass


## Приватный метод. Проверяет персонажа на падениe и испускает сигнал
## [signal started_falling].
func _check_falling() -> void:
	# ToDo.
	pass
