@tool
class_name PlayerAttack
extends CustomNode2D
## Этот класс отвечает за осуществление атаки игрока.
##
## Наследует [CustomNode2D] вместо [CustomNode] из-за ожидаемого наличия
## [HitBox] в качестве дочернего узла. У простого [CustomNode] отсутствуют
## координаты, из-за чего дочерние узлы не смогут их наследовать, что приведёт
## к отделению [HitBox] по координатам от основного содержимого персонажа.

## Была начата атака.
signal attack
## Можно совершить новую атаку.
signal attack_ready

## Параметры атаки игрока.
@export var attack_data: PlayerAttackData
## Компонента движения
@export var movement_component: PlayerMovement
## Название анимации хитбокса
@export var hit_box_animation_name: StringName

# Есть ли ссылка на [PlayerAttackData].
var _has_attack_data := false
# Есть ли ссылка на [PlayerMovement].
var _has_movement_component := false

## [HitBox] данной атаки.
var _hit_box: HitBox
# Есть ли ссылка на [HitBox].
var _has_hit_hox := false

## Необходим для изменения формы [member _hit_box] во время атаки.
var _animation_player: AnimationPlayer
# Есть ли ссылка на [AnimationPlayer].
var _has_animation_player := false

## Можно ли атаковать в данный момент? Необходим для cooldown'а атаки.
var _is_attack_ready := true
## Скорость проигрывания анимации атаки, чтобы его длительность составляла
## [member PlayerAttackData.duration].
var _custom_speed: float


func _init() -> void:
	_class_name = &"PlayerAttack"


func _ready() -> void:
	super()

	if Engine.is_editor_hint():
		return

	if not _has_animation_player:
		push_error("Невозможно изменять hitbox атаки без _animation_player")
		return

	_custom_speed = (
		_animation_player.get_animation(hit_box_animation_name).length / attack_data.duration
	)


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_attack_data = Utilities.check_resource(attack_data, &"PlayerAttackData", warnings)
	_has_movement_component = Utilities.check_reference(
		movement_component, &"PlayerMovement", warnings
	)

	_hit_box = Utilities.check_single_component(self, &"HitBox", warnings)
	if _hit_box != null:
		_has_hit_hox = true

	_animation_player = Utilities.check_single_component(self, &"AnimationPlayer", warnings)
	if _animation_player != null:
		_has_animation_player = true

	return _has_attack_data and _has_movement_component and _has_hit_hox and _has_animation_player


## Осуществляет атаку в направлении [param direction] с сильным импульсом.
## Подобный импульс позволяет спокойно преодолевать гравитацию.
func strong_impulse_attack(direction: Vector2) -> void:
	_attack(direction, attack_data.strong_impulse)


## Осуществляет атаку в направлении [param direction] со слабым импульсом.
## Такой импульс не позволяет набирать высоту против гравитации и, как максимум,
## способен поддерживать персонажа примерно на одной высоте.
func weak_impulse_attack(direction: Vector2) -> void:
	_attack(direction, attack_data.weak_impulse)


## Setter для поля [member attack_data]. Обновляет ошибки конфигурации.
func set_attack_data(value: PlayerAttackData) -> void:
	attack_data = value
	update_configuration_warnings()


## Setter для поля [member movement_component]. Обновляет ошибки конфигурации.
func set_movement_component(value: PlayerMovement) -> void:
	movement_component = value
	update_configuration_warnings()


## Общий метод для осуществления атаки в направлении [param direction] с
## заданным импульсом [param impulse].
func _attack(direction: Vector2, impulse: float) -> void:
	if not _has_hit_hox:
		push_warning("Невозможно осуществить атаку без _hit_box")
		return
	if not _has_animation_player:
		push_warning("Невозможно осуществить атаку без _animation_player")
		return
	if not _has_attack_data:
		push_warning("Невозможно осуществить атаку без attack_data")
		return
	if not _has_movement_component:
		push_warning("Невозможно осуществить атаку без movement_component")
		return
	if not _is_attack_ready:
		return

	_is_attack_ready = false
	attack.emit()

	# Импульс в заданном направлении
	direction = direction.normalized()
	_calc_velocity(direction * impulse)

	# Задать новое направление атаки в ресурс
	_hit_box.attack_data.direction = direction

	# Вращение хитбокса в заданном направлении
	_hit_box.look_at(direction + _hit_box.global_position)
	# Анимация хитбокса во время атаки
	_animation_player.play(hit_box_animation_name, -1, _custom_speed)

	await get_tree().create_timer(attack_data.cooldown + attack_data.duration).timeout
	_is_attack_ready = true
	attack_ready.emit()


func _calc_velocity(velocity: Vector2):
	if sign(movement_component.character_body.velocity.x) == sign(velocity.x):
		velocity.x += movement_component.character_body.velocity.x

	if sign(movement_component.character_body.velocity.y) != sign(velocity.y):
		velocity.y += movement_component.character_body.velocity.y

	movement_component.set_character_velocity(velocity)


## Отменяет атаку при пересечении с твёрдой поверхностью.
func _on_hit_box_hit_solid_surface(_solid_surface: Node2D) -> void:
	if !Engine.is_editor_hint():
		call_deferred("_advance_animation")


## Приватный метод, преждевремменно завершает анимацию. При этом анимация
## "отзеркаливается" к завершению, а не просто прерывается.
func _advance_animation():
	if not _has_animation_player:
		print("Невозможно прервать атаку без _animation_player")

	if _animation_player.is_playing():
		var advance_seconds: float
		advance_seconds = _animation_player.get_animation(hit_box_animation_name).length
		advance_seconds -= 2 * _animation_player.current_animation_position
		_animation_player.advance(advance_seconds)
