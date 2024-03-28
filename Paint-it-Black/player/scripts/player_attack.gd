@tool
class_name PlayerAttack
extends Node2D
## Компонента атаки игрока.
##
## Этот узел отвечает за атаку игрока, предоставляя публичный метод
## [method attack]. Для этого узла обязательны в качестве дочерних узлы
## [HitBox] и [AnimationPlayer].

## Испускается, когда начинается атака.
signal is_attacking

## Параметры атаки игрока.
@export var attack_data: PlayerAttackData
## Компонента движения
@export var movement_component: PlayerMovement

## [HitBox] данной атаки.
var _hit_box: HitBox
## [AnimationPlayer] для изменения [HitBox] во время атаки.
var _animation_player: AnimationPlayer
## Можно ли атаковать в данный момент? Необходим для cooldown'а атаки.
var _is_attack_ready: bool = true
## Скорость проигрывания анимации атаки, чтобы его длительность была
## [member duration].
var _custom_speed: float


## Проверка конфигурации узла на старте.
func _ready():
	# Проверка наличия параметров атаки
	_check_attack_data()

	# Проверка наличия компонент
	_check_hit_box()
	_check_animation_player()

	if not Engine.is_editor_hint():
		_custom_speed = (
			_animation_player.get_animation("hit_box_attack").length / attack_data.duration
		)


## Обработка ошибок конфигурации
func _get_configuration_warnings() -> PackedStringArray:
	# Ошибки конфигурации
	var warnings: PackedStringArray = []

	# Проверка наличия данных
	_check_attack_data(warnings)

	# Проверка наличия компонент
	_check_hit_box(warnings)
	_check_animation_player(warnings)

	return warnings


## Осуществление атаки в заданном направлении, если это возможно.
# ToDo пока костыльная реализация.
func attack(direction: Vector2) -> void:
	if _is_attack_ready:
		_is_attack_ready = false
		is_attacking.emit()

		# Импульс в заданном направлении
		direction = direction.normalized()
		if (
			movement_component.character_body.is_on_floor()
			or movement_component.character_body.is_on_wall()
		):
			movement_component.add_velocity(direction * attack_data.grounded_impulse)
		else:
			movement_component.add_velocity(direction * attack_data.in_air_impulse)

		# Вращение хитбокса в заданном направлении
		_hit_box.look_at(direction + _hit_box.global_position)
		# Изменение хитбокса под атаку
		_animation_player.play("hit_box_attack", -1, _custom_speed)

		await get_tree().create_timer(attack_data.cooldown + attack_data.duration).timeout
		_is_attack_ready = true


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "PlayerAttack"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)


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


## Проверка наличия [HitBox] в качестве дочернего узла.
func _check_hit_box(warnings: PackedStringArray = []) -> void:
	var hit_box_components: Array = get_children().filter(func(node): return node is HitBox)

	if hit_box_components.size() > 1:
		if Engine.is_editor_hint():
			warnings.push_back("Обнаружено несколько компонент HitBox")
		else:
			assert(false, "Обнаружено несколько компонент HitBox")
		_hit_box = null
	elif hit_box_components.size() == 0:
		if Engine.is_editor_hint():
			warnings.push_back("Не найдена компонента HitBox")
		else:
			assert(false, "Не найдена компонента HitBox")
		_hit_box = null
	else:
		_hit_box = hit_box_components[0]

	_hit_box.attack_data = attack_data


## Проверка наличия [AnimationPlayer] в качестве дочернего узла.
func _check_animation_player(warnings: PackedStringArray = []) -> void:
	var animation_players: Array = get_children().filter(func(node): return node is AnimationPlayer)

	if animation_players.size() > 1:
		if Engine.is_editor_hint():
			warnings.push_back("Обнаружено несколько компонент AnimationPlayer")
		else:
			assert(false, "Обнаружено несколько компонент AnimationPlayer")
		_animation_player = null
	elif animation_players.size() == 0:
		if Engine.is_editor_hint():
			warnings.push_back("Не найдена компонента AnimationPlayer")
		else:
			assert(false, "Не найдена компонента AnimationPlayer")
		_animation_player = null
	else:
		_animation_player = animation_players[0]


## Проверка наличия [PlayerMovement].
func _check_player_movement(warnings: PackedStringArray = []) -> void:
	if movement_component == null:
		if Engine.is_editor_hint():
			warnings.push_back("Отсутствует ссылка на PlayerMovement")
		else:
			assert(false, "Отсутствует ссылка на PlayerMovement")


## Проверка наличия данных об атаке.
func _check_attack_data(warnings: PackedStringArray = []) -> void:
	if attack_data == null:
		if Engine.is_editor_hint():
			warnings.push_back("Не обнаружена PlayerAttackData")
		else:
			assert(false, "Не обнаружена PlayerAttackData")
