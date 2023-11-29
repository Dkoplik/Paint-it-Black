@tool
extends Node2D
class_name PlayerAttack
## Компонента атаки игрока.
##
## Этот узел отвечает за атаку игрока, предоставляя публичный метод
## [method attack]. Для этого узла обязательны в качестве дочерних узлы
## [HitBox] и [AnimationPlayer].


## Испускается, когда начинается атака.
signal is_attacking


## Данные об атаке, которые будут передаваться в [HurtBoxInterface].
@export var attack_data: AttackData
## Длительность атаки.
@export_range(0, 5) var duration: float
## Время между атаками.
@export_range(0, 5) var cooldown: float
## Величина импульса / толчка во время атаки.
@export_range(0, 200, 0.1, "or_greater") var impulse: float
## Компонента движения
@export var movement_component: PlayerMovement


## [HitBox] данной атаки.
var _hit_box: HitBox
## [AnimationPlayer] для изменения [HitBox] во время атаки.
var _animation_player: AnimationPlayer


## Проверка конфигурации узла на старте.
func _ready():
	# Проверка наличия данных
	_check_attack_data()
	
	# Проверка наличия компонент
	_check_hit_box()
	_check_animation_player()


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
func attack(direction: Vector2) -> void:
	# Импульс в заданном направлении
	direction = direction.normalized()
	movement_component.add_velocity(direction * impulse)
	
	# Вращение хитбокса в заданном направлении
	_hit_box.look_at(direction + _hit_box.global_position)
	# Изменение хитбокса под атаку
	_animation_player.play("hit_box_attack")


## Проверка наличия [HitBox] в качестве дочернего узла.
func _check_hit_box(warnings: PackedStringArray = []) -> void:
	var hit_box_components: Array =\
		get_children().filter(func(node): return node is HitBox)
	
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
	var animation_players: Array =\
		get_children().filter(func(node): return node is AnimationPlayer)
	
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


## Проверка наличия данных об атаке
func _check_attack_data(warnings: PackedStringArray = []) -> void:
	if attack_data ==  null:
		if Engine.is_editor_hint():
			warnings.push_back("Не обнаружена AttackData")
		else:
			assert(false, "Не обнаружена AttackData")
