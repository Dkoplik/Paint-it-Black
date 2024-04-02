@tool
class_name HitBox
extends CustomArea2D
## Основной hit-box в игре, обнаруживает пересечения с [BasicHurtBox] и его
## наследниками, после чего производит на них атаку.
##
## Вроде как расширение этого класса не потребуется, поскольку он завязан
## чисто на передаче атаки [BasicIncomingAttack], так что любая более
## сложная атака тоже может быть передана, главное - указать правильные
## параметры.

## Испускается, когда была нанесена атака объекту [BasicHurtBox], передаёт
## ссылку на этот объект в параметре [param hurt_box].
signal hit(hurt_box: BasicHurtBox)
## Испускается, когда было обнаружено пересечение с твёрдой поверхностью,
## передаёт ссылку на этот объект в параметре [param solid_surface].
signal hit_solid_surface(solid_surface: Node2D)

## Названия групп, которые данный hitbox может атаковать.
@export var hittable_groups: Array[StringName]
## Параметры атаки, которые будут переданы в [BasicHurtBox] для последующей
## обработки.
@export var attack_data: BasicIncomingAttack

## Есть ли ссылка на [member attack_data].
var _has_attack_data := false


func _init() -> void:
	_class_name = &"HitBox"
	# Соединяет сигналы с самим же объектом, дабы автоматизировать расширенный
	# функционал Area2D.
	connect("area_entered", _on_area_entered)
	connect("body_entered", _on_body_entered)


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_attack_data = Utilities.check_resource(attack_data, "BasicIncomingAttack", warnings)
	return _has_attack_data


## Обрабатывает пересечение с [Area2D]: если [Area2D] является
## [BasicHitBox], то передаёт ему данные об атаке [member attack_data].
func _on_area_entered(area: Area2D) -> void:
	if area is BasicHurtBox:
		# Эту группу можно атаковать?
		if area.get_groups().any(func(group): return group in hittable_groups):
			hit.emit(area)
			if !_has_attack_data:
				push_error("Невозможно осуществить _on_area_entered() без BasicIncomingAttack")
				return
			area.receive_attack(attack_data)


## Обнаруживает пересечение с твёрдой поверхностью, испускает сигнал
## [signal hit_static_body].
func _on_body_entered(body: Node2D) -> void:
	if body is TileMap:
		hit_solid_surface.emit(body)
