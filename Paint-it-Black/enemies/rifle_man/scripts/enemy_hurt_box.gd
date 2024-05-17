@tool
class_name EnemyHurtBox
extends BasicHurtBox

@export var damage_impulse := 200.0
@export var additional_impulse: Vector2
@export var movement_component: BasicCharacterMovement


func _init():
	_class_name = &"EnemyHurtBox"


## Принимает входящую атаку, испускает сигнал [signal hurt] и осуществляет
## реакцию на атаку.
func receive_attack(attack: BasicIncomingAttack) -> void:
	if Engine.is_editor_hint():
		return

	hurt.emit(attack)
	print("enemy hurt")
	if not _has_hp:
		push_error("Невозможно осуществить receive_attack() без компоненты hp")
		return

	hp.deal_damage(attack.damage)

	if "direction" in attack:
		movement_component.set_velocity(damage_impulse * attack.direction + additional_impulse)
