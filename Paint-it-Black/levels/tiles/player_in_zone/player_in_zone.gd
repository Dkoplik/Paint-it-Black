extends Area2D

## Игрок зашёл в обозначенную зону.
signal player_entered
## Игрок зашёл в обозначенную зону. Передаёт ссылку на игрока.
signal player_body_entered(player: CharacterBody2D)

## Группа игрока.
@export var player_group: String
@export var enabled := true
## Если true, то после одного срабатывания автоматически отключается.
@export var one_shot := true


func _on_body_entered(body) -> void:
	if not enabled:
		return

	if body is CharacterBody2D and body.is_in_group(player_group):
		if one_shot:
			enabled = false
		player_entered.emit()
		player_body_entered.emit(body)

