@tool
class_name PlayerAttack
extends CustomNode
## Этот класс отвечает за осуществление атаки игрока.

## Параметры атаки игрока.
@export var attack_data: PlayerAttackData
## Компонента движения
@export var movement_component: PlayerMovement

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
	update_configuration_warnings()

	if Engine.is_editor_hint(): return

	_custom_speed = (
		_animation_player.get_animation("hit_box_attack").length / attack_data.duration
	)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	Utilities.check_resource(attack_data, &"PlayerAttackData", warnings)
	Utilities.check_reference(movement_component, &"PlayerMovement", warnings)

	_hit_box = Utilities.check_single_component(self, &"HitBox", warnings)
	if _hit_box != null: _has_hit_hox = true

	_animation_player = Utilities.check_single_component(self, &"AnimationPlayer", warnings)
	if _animation_player != null: _has_animation_player = true

	return warnings


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
	if not _is_attack_ready: return

	_is_attack_ready = false

	# Импульс в заданном направлении
	direction = direction.normalized()
	movement_component.add_velocity(direction * impulse)

	# Вращение хитбокса в заданном направлении
	_hit_box.look_at(direction + _hit_box.global_position)
	# Анимация хитбокса во время атаки
	_animation_player.play("hit_box_attack", -1, _custom_speed)

	await get_tree().create_timer(attack_data.cooldown + attack_data.duration).timeout
	_is_attack_ready = true


## Отменяет атаку при пересечении с твёрдой поверхностью.
func _on_hit_box_hit_solid_surface(_solid_surface: Node2D) -> void:
	if !Engine.is_editor_hint():
		call_deferred("_advance_animation")


## Приватный метод, преждевремменно завершает анимацию. При этом анимация
## "отзеркаливается" к завершению, а не просто прерывается.
func _advance_animation():
	if _animation_player.is_playing():
		var advance_seconds: float
		advance_seconds = _animation_player.get_animation("hit_box_attack").length
		advance_seconds -= 2 * _animation_player.current_animation_position
		_animation_player.advance(advance_seconds)
