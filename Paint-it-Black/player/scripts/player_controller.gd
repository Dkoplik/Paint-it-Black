@tool
class_name PlayerController
extends CustomNode2D
## Обработчик управления для игрока.
##
## Наследование от [CustomNode2D] позволяет использовать этот узел в качестве
## корня игрока. Этот узел дублирует координаты дочернего [CharacterBody2D],
## благодаря чему остальные компоненты будут следовать за перемещением игрока.

## Компонента движения.
@export var movement_component: PlayerMovement:
	set = set_movement_component
## Компонента атаки.
@export var attack_component: PlayerAttack:
	set = set_attack_component
## Корень StateChart'ов, отвечает за состояния игрока.
@export var state_chart: StateChart:
	set = set_state_chart
## Корень игрока.
@export var root: CharacterBody2D:
	set = set_root

var is_dead := false

## Есть ли компонента [PlayerMovement] в качестве дочернего узла?
var _has_movement_component := false
## Есть ли компонента [PlayerAttack] в качестве дочернего узла?
var _has_attack_component := false
## Есть ли компонента [StateChart] в качестве дочернего узла?
var _has_state_chart := false
## Есть ли ссылка на корень?
var _has_root := false


func _ready() -> void:
	super()

	if Engine.is_editor_hint():
		return

	GameManager.player = root
	$"../BasicHurtBox/HP".connect("killed", GameManager._player_dead)


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_movement_component = Utilities.check_reference(
		movement_component, "PlayerMovement", warnings
	)
	_has_attack_component = Utilities.check_reference(attack_component, "PlayerAttack", warnings)
	_has_state_chart = Utilities.check_reference(state_chart, "StateChart", warnings)
	_has_root = Utilities.check_reference(root, "CharacterBody2D", warnings)
	return _has_movement_component and _has_attack_component and _has_state_chart and _has_root


## Setter для поля [member movement_component]. Обновляет ошибки конфигурации.
func set_movement_component(value: PlayerMovement) -> void:
	movement_component = value
	update_configuration_warnings()


## Setter для поля [member attack_component]. Обновляет ошибки конфигурации.
func set_attack_component(value: PlayerAttack) -> void:
	attack_component = value
	update_configuration_warnings()


## Setter для поля [member state_chart]. Обновляет ошибки конфигурации.
func set_state_chart(value: StateChart) -> void:
	state_chart = value
	update_configuration_warnings()


## Setter для поля [member root]. Обновляет ошибки конфигурации.
func set_root(value: CharacterBody2D) -> void:
	root = value
	update_configuration_warnings()


## Обработка управления перемещения и создание соотевтсвующих ивентов для
## ветки состояний "MovingStates".
func _on_moving_states_state_physics_processing(_delta):
	if Engine.is_editor_hint():
		return

	if is_dead:
		movement_component.decelerate_to_stop()
		return

	if not _has_movement_component:
		push_error("Невозможно осуществить движение без _movement_component")
		return

	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if direction == Vector2.ZERO:
		movement_component.decelerate_to_stop()
		state_chart.send_event("stop_moving")
	else:
		movement_component.move_in_direction(direction)
		state_chart.send_event("start_moving")


## Обработка ивентов для переключения между состояниями в ветке "Jump&FallStates".
func _on_jump_fall_states_state_physics_processing(_delta):
	if Engine.is_editor_hint():
		return

	if is_dead:
		return

	if not _has_movement_component:
		push_error("Невозможно обработать текущее состояние игрока без _movement_component")
		return

	if movement_component.character_body.is_on_floor():
		state_chart.send_event("land")
	elif movement_component.character_body.is_on_wall():
		state_chart.send_event("wall_collision")
	elif movement_component.character_body.velocity.y > 0:
		state_chart.send_event("fall")


## Обработка прыжка из состояний в ветке "CanJump". Из других состояний
## совершить прыжок нельзя.
func _on_can_jump_state_unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if is_dead:
		return

	if event.is_action_pressed("jump"):
		if not _has_movement_component:
			push_error("Невозможно совершить прыжок без _movement_component")
			return

		movement_component.jump()
		# Необходима небольшая пауза, иначе игрок не успеет оторваться от земли,
		# из-за чего из состояния "jump" сразу же перейдёт в "grounded".
		await AutoloadUtilities.wait_for(0.05)
		state_chart.send_event("jump")


## Обработка сильной атаки
func _on_can_strong_attack_state_unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if is_dead:
		return

	if event.is_action_pressed("attack"):
		if not _has_movement_component:
			push_error("Невозможно совершить атаку без _movement_component")
			return
		var attack_direction: Vector2 = _get_attack_direction()
		attack_component.strong_impulse_attack(attack_direction)


## Обработка слабой атаки
func _on_can_weak_attack_state_unhandled_input(event: InputEvent):
	if Engine.is_editor_hint():
		return

	if is_dead:
		return

	if event.is_action_pressed("attack"):
		if not _has_movement_component:
			push_error("Невозможно совершить атаку без _movement_component")
			return
		var attack_direction: Vector2 = _get_attack_direction()
		attack_component.weak_impulse_attack(attack_direction)


func _get_attack_direction() -> Vector2:
	var global_mouse_pos: Vector2 = get_global_mouse_position()
	return global_mouse_pos - movement_component.character_body.position

func _on_player_attack_attack():
	state_chart.send_event("attack")


func _on_player_attack_attack_ready():
	state_chart.send_event("attack_ready")


func _on_hit_box_hit(hurt_box):
	if hurt_box is Parryable:
		return
	GameManager.on_hit_hit_stop()


func _on_basic_hurt_box_hurt(_attack):
	GameManager.on_hurt_hit_stop()


func _on_stay_on_platform_state_unhandled_input(event: InputEvent):
	if event.is_action_pressed("fall_through_platform"):
		state_chart.send_event("fall_through_platform")


func _on_stay_on_platform_state_entered():
	movement_component.turn_on_platform_collision()


func _on_fall_though_platform_state_unhandled_input(event):
	if event.is_action_released("fall_through_platform"):
		state_chart.send_event("stay_on_platform")


func _on_fall_though_platform_state_entered():
	movement_component.turn_off_platform_collision()


func turn_on_is_dead() -> void:
	is_dead = true
