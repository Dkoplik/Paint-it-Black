@tool
class_name RifleManBlackboard
extends Blackboard

## Ссылка на компоненту [HP].
@export var hp_component: HP:
	set = set_hp_component
## Ссылка на компоненту [BasicCharacterMovement].
@export var movement_component: BasicCharacterMovement:
	set = set_movement_component
## Ссылка на компоненту [ShootComponent].
@export var shoot_component: ShootComponent:
	set = set_shoot_component
## Ссылка на компоненту [BeehaveTree].
@export var beehave_tree: BeehaveTree:
	set = set_beehave_tree

## Есть ли ссылка на [HP]?
var _has_hp_component := false
## Есть ли ссылка на [BasicCharacterMovement]?
var _has_movement_component := false
## Есть ли ссылка на [ShootComponent]?
var _has_shoot_component := false
## Есть ли ссылка на [BeehaveTree]?
var _has_beehave_tree := false


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	check_configuration()

	if not _has_hp_component:
		push_error("Невозможно продолжить без компоненты hp")

	if not _has_movement_component:
		push_error("Невозможно продолжить без компоненты movement")
		
	set_value("hp_component", hp_component)
	set_value("movement_component", movement_component)
	set_value("shoot_component", shoot_component)
	set_value("beehave_tree", beehave_tree)
	set_value("target", GameManager.player)


func _get_configuration_warnings():
	var warnings: PackedStringArray = []
	check_configuration(warnings)
	return warnings


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_hp_component = Utilities.check_reference(hp_component, "HP", warnings)
	_has_movement_component = Utilities.check_reference(movement_component, "BasicCharacterMovement", warnings)
	_has_shoot_component = Utilities.check_reference(shoot_component, "ShootComponent", warnings)
	_has_beehave_tree = Utilities.check_reference(beehave_tree, "BeehaveTree", warnings)
	return _has_hp_component and _has_movement_component and _has_shoot_component and _has_beehave_tree


func set_hp_component(value: HP) -> void:
	hp_component = value
	update_configuration_warnings()


func set_movement_component(value: BasicCharacterMovement) -> void:
	movement_component = value
	update_configuration_warnings()


func set_shoot_component(value: ShootComponent) -> void:
	shoot_component = value
	update_configuration_warnings()


func set_beehave_tree(value: BeehaveTree) -> void:
	beehave_tree = value
	update_configuration_warnings()
