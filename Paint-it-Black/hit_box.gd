extends Area2D
class_name HitBox
## Основной hit-box в игре.
##
## hit-box, обнаруживающий пересечение с [HurtBoxInterface] и его наследниками,
## передавая им параметры атаки [member attack_data]. Этот hit-box реагирует
## на абсолютно все [HurtBoxInterface], если нужно задать другое поведение, то
## следует унаследовать эту компоненту и переопределить метод
## [method _on_area_entered].

## Испускается, когда была нанесена атака объекту [HurtBoxInterface], передаёт
## ссылку на этот объект в параметре [param hurt_box].
signal hit(area: Area2D)

## Параметры атаки, которые будут переданы в [HurtBoxInterface] для последующей
## обработки.
@export var attack_data: AttackData
## Массив названий групп, которые данный [HitBox] может атаковать.
@export var hittable_groups: Array[StringName]


## Проверяет наличие данных об атаке
func _ready():
	assert(attack_data != null, "Отсутствует AttackData")


## Связывает сигнал [signal area_entered] из родительского класса [Area2D] с
## приватным методом [method _on_area_entered].
func _init() -> void:
	connect("area_entered", _on_area_entered)


## Обрабатывает пересечение с [Area2D]: если [Area2D] является
## [HurtBoxInterface], то передаёт ему данные об атаке [member attack_data].
func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxInterface:
		# Эту группу можно атаковать?
		if area.get_groups().any(func(group): return group in hittable_groups):
			hit.emit(area)
			area._hurt(attack_data)
