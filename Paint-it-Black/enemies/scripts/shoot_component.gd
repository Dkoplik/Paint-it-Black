class_name ShootComponent
extends Node
## Эта компонента отвечает за стрельбу.

## Данные о стрельбе
@export var shoot_data: ShootData
## Точка появления снарядов
@export var projectile_spawn: Marker2D
## Направление стрельбы
var direction: Vector2
## Время до следующего выстрела
var _cooldown: float


func _ready() -> void:
	_cooldown = 0


func _process(delta) -> void:
	if (_cooldown > 0):
		_cooldown = max(0, _cooldown - delta)


## Совершает выстрел. Если выстрел невозможен, возвращает false, иначе
## возвращает true.
func attack() -> bool:
	if (_cooldown > 0):
		return false
	
	var projectile: Node2D = shoot_data.projectile.instantiate()
	
	var spread_angle := randf_range(-shoot_data.spread_angle, shoot_data.spread_angle)
	var cur_direction := direction.rotated(spread_angle)
	projectile.look_at(cur_direction)
	projectile.position = projectile_spawn.position
	
	_cooldown = shoot_data.cooldown
	
	get_tree().root.add_child(projectile)
	return true


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "ShootComponent"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false.
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)
