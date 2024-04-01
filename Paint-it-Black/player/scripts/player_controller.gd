@tool
class_name PlayerController
extends CustomNode
## Обработчик управления для игрока.
##
## Наследование от [CustomNode2D] позволяет использовать этот узел в качестве
## корня игрока. Этот узел дублирует координаты дочернего [CharacterBody2D],
## благодаря чему остальные компоненты будут следовать за перемещением игрока.

# ToDo для @export полей нужны setter'ы с обновлением ошибок конфигурации
## Компонента движения
@export var movement_component: PlayerMovement
## Компонента атаки
@export var attack_component: PlayerAttack
## Корень StateChart'ов, отвечает за состояния игрока
@export var state_chart: StateChart

## Есть ли компонента [PlayerMovement] в качестве дочернего узла?
var _has_movement_component := false
## Есть ли компонента [PlayerAttack] в качестве дочернего узла?
var _has_attack_component := false
## Есть ли компонента [StateChart] в качестве дочернего узла?
var _has_state_chart := false


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_movement_component = Utilities.check_reference(movement_component, "PlayerMovement", warnings)
	_has_attack_component = Utilities.check_reference(attack_component, "PlayerAttack", warnings)
	_has_state_chart = Utilities.check_reference(state_chart, "StateChart", warnings)
	return _has_movement_component and _has_attack_component and _has_state_chart


## Обработка управления перемещения и создание соотевтсвующих ивентов для
## ветки состояний "MovingStates".
func _on_moving_states_state_physics_processing(delta):
	if Engine.is_editor_hint():
		return

	if not _has_movement_component:
		push_error("Невозможно осуществить движение без _movement_component")
		return

	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if (direction == Vector2.ZERO):
		movement_component.decelerate_to_stop()
		state_chart.send_event("stop_moving")
	else:
		movement_component.move_in_direction(direction)
		state_chart.send_event("start_moving")


## Обработка ивентов для переключения между состояниями в ветке "Jump&FallStates".
func _on_jump_fall_states_state_physics_processing(delta):
	if Engine.is_editor_hint():
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

	if event.is_action_pressed("jump"):
		if not _has_movement_component:
			push_error("Невозможно совершить прыжок без _movement_component")
			return

		movement_component.jump()
		# Необходима небольшая пауза, иначе игрок не успеет оторваться от земли,
		# из-за чего из состояния "jump" сразу же перейдёт в "grounded".
		await Utilities.wait_for(0.05)
		state_chart.send_event("jump")


## Обработка сильной атаки
func _on_can_strong_attack_state_unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if event.is_action_pressed("attack"):
		if not _has_movement_component:
			push_error("Невозможно совершить атаку без _movement_component")
			return
		var attack_direction: Vector2 = get_viewport().get_mouse_position() - movement_component.character_body.position
		attack_component.strong_impulse_attack(attack_direction)


## Обработка слабой атаки
func _on_can_weak_attack_state_unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if event.is_action_pressed("attack"):
		if not _has_movement_component:
			push_error("Невозможно совершить атаку без _movement_component")
			return
		var attack_direction: Vector2 = get_viewport().get_mouse_position() - movement_component.character_body.position
		attack_component.weak_impulse_attack(attack_direction)


func _on_player_attack_attack():
	state_chart.send_event("attack")


func _on_player_attack_attack_ended():
	state_chart.send_event("attack_end")
