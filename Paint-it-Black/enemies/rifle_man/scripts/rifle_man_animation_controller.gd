@tool
class_name RifleManAnimationController
extends CustomNode
## Отвечает за анимации rifle man на основе состояний из [StateChart].

## Произошёл один шаг в анимации бега. В этот момент стоит воспроизвести звук
## шага.
signal step

# ToDo setter'ы с обновлением ошибок конфигурации
## Корень StateChart'ов, отвечает за состояния игрока
@export var state_chart: StateChart
## Покадровые анимации игрока
@export var animated_sprite: AnimatedSprite2D
@export var root: CharacterBody2D
@export var head_part: Node2D
@export var arms_part: Node2D

## Есть ли компонента [StateChart] в качестве дочернего узла?
var _has_state_chart := false
## Есть ли компонента [AnimatedSprite2D] в качестве дочернего узла?
var _has_animated_sprite := false


func _ready() -> void:
	super()
	head_part.visible = false
	arms_part.visible = false


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_state_chart = Utilities.check_reference(state_chart, "StateChart", warnings)
	_has_animated_sprite = Utilities.check_reference(animated_sprite, "AnimatedSprite2D", warnings)
	return _has_state_chart and _has_animated_sprite


## Указать, что игрок теперь смотрит направо
func enemy_look_right() -> void:
	animated_sprite.flip_h = false
	$"../BodyParts/Head/ShootHead".flip_h = false
	$"../BodyParts/Arms/ShootArms".flip_h = false


## Указать, что игрок теперь смотрит налево
func enemy_look_left() -> void:
	animated_sprite.flip_h = true
	$"../BodyParts/Head/ShootHead".flip_h = true
	$"../BodyParts/Arms/ShootArms".flip_h = true


func _on_moving_state_entered():
	animated_sprite.play("move")


func _on_combat_state_entered():
	animated_sprite.play("shoot_body")
	head_part.visible = true
	arms_part.visible = true


func _on_cooldown_state_physics_processing(_delta):
	var player_coords: Vector2 = _get_player_coords()
	var direction_to_player: Vector2 = player_coords - root.global_position

	if direction_to_player.x < 0:
		enemy_look_left()
		player_coords = get_simmetric_point(player_coords, root.global_position)
	elif direction_to_player.x > 0:
		enemy_look_right()

	# ToDo надо сделать так, чтобы после отзеркаливания направление вращения тоже зеркалилось.
	
	head_part.look_at(player_coords)
	arms_part.look_at(player_coords)


func _get_player_coords() -> Vector2:
	var player: CharacterBody2D = GameManager.player
	return player.global_position


func get_simmetric_point(point: Vector2, anchor: Vector2) -> Vector2:
	if (point.x > anchor.x):
		push_warning("Функция не рассчитана на такие параметры")
	var diff: Vector2 = anchor - point
	anchor += diff
	return anchor


func _on_combat_state_exited():
	head_part.visible = false
	arms_part.visible = false


func _on_death_state_entered():
	animated_sprite.play("death")


func _on_animated_sprite_2d_frame_changed():
	match animated_sprite.animation:
		"move":
			match animated_sprite.frame:
				1, 2:
					step.emit()
