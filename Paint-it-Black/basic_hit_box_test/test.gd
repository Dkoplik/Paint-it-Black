extends Node2D

func _on_player_hurt_box_hurt(attack: AttackData):
	print("---")
	print("Получена атака: ", attack)
	print("Урон: ", attack.damage)
	print("---")
