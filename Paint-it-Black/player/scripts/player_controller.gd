@tool
class_name PlayerController
extends CustomNode2D
## Обработчик управления для игрока.
##
## Наследование от [CustomNode2D] позволяет использовать этот узел в качестве
## корня игрока. Этот узел дублирует координаты дочернего [CharacterBody2D],
## благодаря чему остальные компоненты будут следовать за перемещением игрока.

## Компонента движения
var _movement_component: PlayerMovement
## Есть ли компонента [PlayerMovement] в качестве дочернего узла?
var _has_movement_component := false
## Компонента атаки
var _attack_component: PlayerAttack
## Есть ли компонента [PlayerAttack] в качестве дочернего узла?
var _has_attack_component := false


## Обработка управления игрока
func _unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if not _has_movement_component:
		push_error("Невозможно обработать движение без _movement_component")
		return

	# Движение
	var direction := Vector2.ZERO
	if event.is_action_pressed("move_left"):
		direction.x -= 1
	if event.is_action_pressed("move_right"):
		direction.x += 1
	if direction == Vector2.ZERO:
		_movement_component.decelerate_to_stop()
	else:
		_movement_component.move_in_direction(direction)

	# Прыжок
	if event.is_action_pressed("jump"):
		_movement_component.jump()

	if not _has_attack_component:
		push_error("Невозможно обработать атаку без _attack_component")
		return

	# Атака
	if event.is_action_pressed("attack"):
		_attack_component.attack(get_viewport().get_mouse_position() - position)


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_movement_component = Utilities.check_single_component(self, "PlayerMovement", warnings)
	if _movement_component != null:
		_has_movement_component = true

	_attack_component = Utilities.check_single_component(self, "PlayerAttack", warnings)
	if _attack_component != null:
		_has_attack_component = true

	return _has_movement_component && _has_attack_component
