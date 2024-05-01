@tool
class_name ShootComponent
extends CustomNode
## Эта компонента отвечает за стрельбу.

signal attack
signal attack_ready

## Данные о стрельбе
@export var shoot_data: ShootData:
	set = set_shoot_data
## Точка появления снарядов
@export var projectile_spawn: Marker2D:
	set = set_projectile_spawn
## Корень игрока.
@export var root: CharacterBody2D:
	set = set_root

## Есть ли ссылка на [ShootData]?
var _has_shoot_data := false
## Есть ли ссылка на [Marker2D]?
var _has_projectile_spawn := false
## Есть ли ссылка на [CharacterBody2D]?
var _has_root := false
## Время до следующего выстрела
var _cooldown := 0.0


func _init() -> void:
	_class_name = &"ShootComponent"


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_shoot_data = Utilities.check_resource(shoot_data, "ShootData", warnings)
	_has_projectile_spawn = Utilities.check_reference(projectile_spawn, "Marker2D", warnings)
	_has_root = Utilities.check_reference(root, "CharacterBody2D", warnings)
	return _has_shoot_data and _has_projectile_spawn and _has_root


## Setter для поля [member shoot_data]. Обновляет ошибки конфигурации.
func set_shoot_data(value: ShootData) -> void:
	shoot_data = value
	update_configuration_warnings()


## Setter для поля [member projectile_spawn]. Обновляет ошибки конфигурации.
func set_projectile_spawn(value: Marker2D) -> void:
	projectile_spawn = value
	update_configuration_warnings()


## Setter для поля [member root]. Обновляет ошибки конфигурации.
func set_root(value: CharacterBody2D) -> void:
	root = value
	update_configuration_warnings()


## Совершает выстрел. Если выстрел невозможен, возвращает false, иначе
## возвращает true.
func shoot_in_direction(direction: Vector2) -> bool:
	if Engine.is_editor_hint():
		return false

	if not is_shot_ready():
		return false

	attack.emit()
	var projectile: Node2D = shoot_data.projectile.instantiate()

	var spread_angle := randf_range(-shoot_data.spread_angle, shoot_data.spread_angle)
	var cur_direction := direction.rotated(spread_angle)
	projectile.look_at(cur_direction)
	projectile.position = projectile_spawn.global_position

	get_tree().root.add_child(projectile)
	return true


## Совершает выстрел. Если выстрел невозможен, возвращает false, иначе
## возвращает true.
func shoot_target(target: Node2D) -> bool:
	var shoot_direction := (target.global_position - projectile_spawn.global_position).normalized()
	return shoot_in_direction(shoot_direction)


func is_in_shoot_range(target: Node2D) -> bool:
	return Utilities.distance_between(root, target) <= shoot_data.shoot_range


func is_shot_ready() -> bool:
	return _cooldown <= 0.0


## Сбрасывает [member _cooldown], то есть необходимо ждать заново.
func reset_cooldown() -> void:
	_cooldown = shoot_data.cooldown


## Обновляет значение [member _cooldown] в соответсвии с пройденным временем.
func tick_cooldown(delta: float) -> void:
	if _cooldown <= 0.0: # Сигнал attack_ready достаточно испустить 1 раз
		return

	_cooldown = max(0.0, _cooldown - delta)
	if _cooldown <= 0.0:
		attack_ready.emit()
