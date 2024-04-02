@tool
class_name ShootComponent
extends CustomNode
## Эта компонента отвечает за стрельбу.

signal attack
signal attack_ready

## Данные о стрельбе
@export var shoot_data: ShootData
## Точка появления снарядов
@export var projectile_spawn: Marker2D

## Есть ли ссылка на [ShootData]?
var _has_shoot_data := false
## Есть ли ссылка на [Marker2D]?
var _has_projectile_spawn := false
## Время до следующего выстрела
var _cooldown := 0.0


func _init() -> void:
	_class_name = &"ShootComponent"


func _physics_process(delta) -> void:
	if Engine.is_editor_hint():
		return

	if _cooldown > 0:
		_cooldown = max(0, _cooldown - delta)
		if _cooldown == 0:
			attack_ready.emit()


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_shoot_data = Utilities.check_resource(shoot_data, "ShootData", warnings)
	_has_projectile_spawn = Utilities.check_reference(projectile_spawn, "Marker2D", warnings)
	return _has_shoot_data and _has_projectile_spawn


## Совершает выстрел. Если выстрел невозможен, возвращает false, иначе
## возвращает true.
func shoot_in_direction(direction: Vector2) -> bool:
	if Engine.is_editor_hint():
		return false

	if _cooldown > 0:
		return false

	attack.emit()
	var projectile: Node2D = shoot_data.projectile.instantiate()

	var spread_angle := randf_range(-shoot_data.spread_angle, shoot_data.spread_angle)
	var cur_direction := direction.rotated(spread_angle)
	projectile.look_at(cur_direction)
	projectile.position = projectile_spawn.position

	_cooldown = shoot_data.cooldown

	get_tree().root.add_child(projectile)
	return true
