@tool
class_name PlayerAnimationController
extends CustomNode
## Отвечает за анимации игрока на основе состояний из [StateChart].

## Произошёл один шаг в анимации бега. В этот момент стоит воспроизвести звук
## шага.
signal step

# ToDo setter'ы с обновлением ошибок конфигурации
## Корень StateChart'ов, отвечает за состояния игрока
@export var state_chart: StateChart
## Покадровые анимации игрока
@export var animated_sprite: AnimatedSprite2D

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
	animated_sprite.flip_h = false


## Указать, что игрок теперь смотрит налево
func player_look_left() -> void:
	animated_sprite.flip_h = true


func _on_idle_animation_state_entered():
	animated_sprite.play("idle")


func _on_run_animation_state_entered():
	animated_sprite.play("run")


func _on_jump_state_entered():
	animated_sprite.play("jump")


func _on_falling_state_entered():
	animated_sprite.play("fall")


func _on_on_wall_state_entered():
	animated_sprite.flip_h = !animated_sprite.flip_h
	animated_sprite.play("wall")


func _on_on_wall_state_exited():
	animated_sprite.flip_h = !animated_sprite.flip_h


func _on_attack_state_entered():
	animated_sprite.play("attack")
	$"../VFX".show()
	$"../VFX".play("vfx_slash")


func _on_animated_sprite_2d_frame_changed():
	match animated_sprite.animation:
		"run":
			match animated_sprite.frame:
				1, 3, 5:
					step.emit()
