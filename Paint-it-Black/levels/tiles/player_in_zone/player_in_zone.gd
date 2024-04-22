extends Area2D

## Игрок зашёл в обозначенную зону.
signal player_entered
## Игрок зашёл в обозначенную зону. Передаёт ссылку на игрока.
signal player_body_entered(player: CharacterBody2D)

## Группа игрока.
@export var player_group: String


func _on_body_entered(body):
	if body is CharacterBody2D and body.is_in_group(player_group):
		player_entered.emit()
		player_body_entered.emit(body)
