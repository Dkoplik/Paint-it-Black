extends Area2D

## Игрок зашёл в обозначенную зону.
signal player_entered(player: CharacterBody2D)

## Группа игрока.
@export var player_group: String


func _on_body_entered(body):
	if body is CharacterBody2D and body.is_in_group(player_group):
		player_entered.emit(body)
