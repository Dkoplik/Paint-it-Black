class_name HitBox
extends Area2D
## Основной hit-box в игре.
##
## hit-box, обнаруживающий пересечение с [HurtBoxInterface] и его наследниками,
## передавая им параметры атаки [member attack_data]. Этот hit-box реагирует
## на абсолютно все [HurtBoxInterface], если нужно задать другое поведение, то
## следует унаследовать эту компоненту и переопределить метод
## [method _on_area_entered].

## Испускается, когда была нанесена атака объекту [HurtBoxInterface], передаёт
## ссылку на этот объект в параметре [param hurt_box].
signal hit(hurt_box: HurtBoxInterface)
## Испускается, когда было обнаружено пересечение с твёрдой поверхностью.
signal hit_solid_surface(solid_surface: Node2D)

## Параметры атаки, которые будут переданы в [HurtBoxInterface] для последующей
## обработки.
@export var attack_data: AttackData
## Массив названий групп, которые данный [HitBox] может атаковать.
@export var hittable_groups: Array[StringName]


## Проверяет наличие данных об атаке
func _ready():
	assert(attack_data != null, "Отсутствует AttackData")
	# ToDo переделать этот костыль
	$HitBoxShape.disabled = true
	$HitBoxShape.visible = false


## Связывает нужные сигналы с соответствующими функциями, дабы расширить
## функционал базового [Aread2D].
func _init() -> void:
	connect("area_entered", _on_area_entered)
	connect("body_entered", _on_body_entered)


## Возвращает название класса в строковом виде.
func get_class_name() -> String:
	return "HitBox"


## Возвращает true, если указанная строка [param name] является названием
## текущего класса или одного из его предков в строковом виде, иначе false
func is_class_name(name: String) -> bool:
	return name == get_class_name() or self.is_class(name)


## Обрабатывает пересечение с [Area2D]: если [Area2D] является
## [HurtBoxInterface], то передаёт ему данные об атаке [member attack_data].
func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxInterface:
		# Эту группу можно атаковать?
		if area.get_groups().any(func(group): return group in hittable_groups):
			var attack = IncomingAttack.new()
			attack.damage = attack_data.damage
			hit.emit(area)
			area.hurt(attack)


## Обнаруживает пересечение с твёрдой поверхностью испускает сигнал
## [signal hit_static_body].
func _on_body_entered(body: Node2D) -> void:
	if body is TileMap:
		hit_solid_surface.emit(body)
