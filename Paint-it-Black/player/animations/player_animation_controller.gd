@tool
class_name PlayerAnimationController
extends CustomNode
## Отвечает за анимации игрока на основе состояний из [StateChart].

# ToDo setter'ы с обновлением ошибок конфигурации
## Корень StateChart'ов, отвечает за состояния игрока
@export var state_chart: StateChart
## Покадровые анимации игрока
@export var animated_sprite: AnimatedSprite2D

## Постфикс анимации, который определяет направление анимации: влево или вправо
var animation_postfix := "_right"

## Есть ли компонента [StateChart] в качестве дочернего узла?
var _has_state_chart := false
## Есть ли компонента [AnimatedSprite2D] в качестве дочернего узла?
var _has_animated_sprite := false


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_state_chart = Utilities.check_reference(state_chart, "StateChart", warnings)
	_has_animated_sprite = Utilities.check_reference(animated_sprite, "AnimatedSprite2D", warnings)
	return _has_state_chart and _has_animated_sprite


## Указать, что игрок теперь смотрит направо
func player_look_right() -> void:
	animation_postfix = "_right"
	_change_animation_direction_to(animation_postfix)


## Указать, что игрок теперь смотрит налево
func player_look_left() -> void:
	animation_postfix = "_left"
	_change_animation_direction_to(animation_postfix)


## Заменяет текущую анимацию на зеркальный вариант, не прерывая прогресс
## анимации.
func _change_animation_direction_to(new_postfix: String) -> void:
	var animation_info: PackedStringArray = animated_sprite.animation.split("_")
	var animation_name: String = animation_info[0]
	var new_animation: String = animation_name + new_postfix

	var current_frame: int = animated_sprite.frame
	var current_frame_progress: float = animated_sprite.frame_progress

	animated_sprite.play(new_animation)
	animated_sprite.set_frame_and_progress(current_frame, current_frame_progress)


func _on_idle_animation_state_entered():
	animated_sprite.play("idle" + animation_postfix)


func _on_run_animation_state_entered():
	animated_sprite.play("run" + animation_postfix)


func _on_jump_state_entered():
	animated_sprite.play("jump" + animation_postfix)


func _on_falling_state_entered():
	animated_sprite.play("fall" + animation_postfix)


func _on_on_wall_state_entered():
	animated_sprite.play("wall" + animation_postfix)


func _on_attack_state_entered():
	animated_sprite.play("attack" + animation_postfix)
