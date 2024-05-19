@tool
class_name EnemyHurtBox
extends BasicHurtBox

@export var damage_impulse := 200.0
@export var additional_impulse: Vector2
@export var movement_component: BasicCharacterMovement

var blood_particles: PackedScene = preload("res://enemies/blood_particles/blood_particles.tscn")

func _init():
	_class_name = &"EnemyHurtBox"


## Принимает входящую атаку, испускает сигнал [signal hurt] и осуществляет
## реакцию на атаку.
func receive_attack(attack: BasicIncomingAttack) -> void:
	if Engine.is_editor_hint():
		return

	hurt.emit(attack)
	if not _has_hp:
		push_error("Невозможно осуществить receive_attack() без компоненты hp")
		return

	hp.deal_damage(attack.damage)

	if "direction" in attack:
		movement_component.set_velocity(damage_impulse * attack.direction + additional_impulse)
		var particles = blood_particles.instantiate()
		particles.global_position = global_position
		get_tree().root.add_child(particles)
		particles.emit_in_direction(attack.direction)
