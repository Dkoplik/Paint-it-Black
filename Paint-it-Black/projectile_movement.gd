@tool
class_name ProjectileMovement
extends Node
## Этот класс отвечает за движение снарядов.
##
## [ProjectileMovement] содержит логику движения снарядов, при этом не является
## для них главным узлом. Иными словами, этот узел должен содержать ссылку на
## корневой узел, который эта компонента будет двигать.

## Постоянная скорость снаряда, с которой он движется.
@export_range(0, 300, 0.1, "or_greater") var speed: float:
	set = set_speed,
	get = get_speed
## Корневой узел снаряда. Именно этот узел будет двигать данная компонента.
@export var root_node: Node2D:
	set = set_root,
	get = get_root


## Проверяет наличие корневого узла.
func _ready() -> void:
	if !Engine.is_editor_hint():
		pass
		# ToDo: проверить наличие корневого узла. Если он отсутствует, то
		# прервать программу через assert.


## Запускает движение снаряда.
func _process(delta) -> void:
	_move(delta)


## Выполняет движение [member root_node] по его направлению вперёд со скоростью
## [member speed].
func _move(_delta: float) -> void:
	if !Engine.is_editor_hint():
		# ToDo: получить направление, куда повёрнут корневой узел, и в этом
		# Направлении сместить корневой узел на значение speed * delta.
		pass


## Setter для поля [member speed]. Не позволяет установить отрицательную
## скорость движения.
func set_speed(value: float) -> void:
	if value >= 0:
		speed = value


## Getter для поля [member speed].
func get_speed() -> float:
	return 0  # ToDo: просто возвращает скорость.


## Setter для поля [member root_node]. Не позволяет изменить корневой узел во
## время игры.
func set_root(value: Node2D) -> void:
	if !Engine.is_editor_hint():
		# ToDo: если root_node ещё Null, то присвоить новое значение, иначе не
		# менять значение переменной и бросить ошибку через push_error() о
		# попытке изменить корневой узел.
		pass
	else:
		root_node = value


## Getter для поля [member root_node].
func get_root() -> Node2D:
	return null  # ToDo просто вернуть root_node
