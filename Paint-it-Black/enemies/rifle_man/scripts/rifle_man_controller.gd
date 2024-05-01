@tool
class_name RifleManController
extends CustomNode
## ИИ врага-стрелка.

## Компонента движения.
@export var movement_component: BasicCharacterMovement:
	set = set_movement_component
## Компонента атаки.
@export var shoot_component: ShootComponent:
	set = set_shoot_component
## Корень StateChart'ов, отвечает за состояния игрока.
@export var state_chart: StateChart:
	set = set_state_chart
## Корень игрока.
@export var root: CharacterBody2D:
	set = set_root

## Есть ли компонента [PlayerMovement] в качестве дочернего узла?
var _has_movement_component := false
## Есть ли компонента [PlayerAttack] в качестве дочернего узла?
var _has_shoot_component := false
## Есть ли компонента [StateChart] в качестве дочернего узла?
var _has_state_chart := false
## Есть ли ссылка на корень?
var _has_root := false
## Ссылка на игрока
var _player: CharacterBody2D


func _ready() -> void:
	super()

	if Engine.is_editor_hint():
		return

	_player = GameManager.player


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_movement_component = Utilities.check_reference(
		movement_component, "PlayerMovement", warnings
	)
	_has_shoot_component = Utilities.check_reference(shoot_component, "PlayerAttack", warnings)
	_has_state_chart = Utilities.check_reference(state_chart, "StateChart", warnings)
	_has_root = Utilities.check_reference(root, "CharacterBody2D", warnings)
	return _has_movement_component and _has_shoot_component and _has_state_chart and _has_root


## Setter для поля [member movement_component]. Обновляет ошибки конфигурации.
func set_movement_component(value: BasicCharacterMovement) -> void:
	movement_component = value
	update_configuration_warnings()


## Setter для поля [member shoot_component]. Обновляет ошибки конфигурации.
func set_shoot_component(value: ShootComponent) -> void:
	shoot_component = value
	update_configuration_warnings()


## Setter для поля [member state_chart]. Обновляет ошибки конфигурации.
func set_state_chart(value: StateChart) -> void:
	state_chart = value
	update_configuration_warnings()


## Setter для поля [member root]. Обновляет ошибки конфигурации.
func set_root(value: CharacterBody2D) -> void:
	root = value
	update_configuration_warnings()


func _on_moving_states_state_physics_processing(_delta: float) -> void:
	if shoot_component.is_in_shoot_range(_player):
		state_chart.send_event("player_in_range")
	else:
		state_chart.send_event("player_out_of_range")


func _on_moving_to_player_state_physics_processing(_delta: float) -> void:
	movement_component.move_to_target(_player)


func _on_shoot_state_entered() -> void:
	shoot_component.shoot_target(_player)
