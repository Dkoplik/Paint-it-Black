extends Node2D


func emit_in_direction(direction: Vector2) -> void:
	$CPUParticles2D.direction = direction
	$CPUParticles2D.emitting = true
	$Timer.start()
