extends CharacterBody2D


# Костыль
func _on_hp_killed():
	$Sprite2D.modulate.a = 0.2
	$PlayerHurtBox/HurtBoxShape.modulate.a = 0.2
	$PhysicsShape.modulate.a = 0.2
	await get_tree().create_timer(0.6).timeout
	queue_free()
