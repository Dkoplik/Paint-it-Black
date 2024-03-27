@tool
class_name BasicHurtBox
extends CustomArea2D
## Основная компонента hurtbox, отвечает за получение и обработку входящих
## атак.
##
## Этот класс является базовым и обрабатывает атаки вида [BasicIncomingAttack],
## для обработки других типов атак необходимо унаследовать этот класс и
## переопределить метод [method receive_attack()].

## Испускается, когда была получена атака. [param attack] передаёт параметры
## входящей атаки.
signal hurt(attack: BasicIncomingAttack)

## Ссылка на узел-компоненту [HP], автоматически ищется среди дочерних узлов.
var _hp: HP = null
## Есть ли ссылка на компоненту [HP].
var _has_hp := false


func _init():
	_class_name = &"BasicHurtBox"


func _ready() -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	_hp = Utilities.check_single_component(self, &"HP", warnings)
	if _hp != null:
		_has_hp = true

	return warnings


## Принимает входящую атаку, испускает сигнал [signal hurt] и осуществляет
## реакцию на атаку.
func receive_attack(attack: BasicIncomingAttack) -> void:
	if Engine.is_editor_hint():
		return

	hurt.emit(attack)
	if not _has_hp:
		push_error("Невозможно осуществить receive_attack() без компоненты hp")
		return

	_hp.deal_damage(attack.damage)
