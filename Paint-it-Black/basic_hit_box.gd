extends Area2D
class_name BasicHitBox
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

## Параметры атаки, которые будут переданы в [HurtBoxInterface] для последующей
## обработки.
@export var attack_data: AttackData


## Связывает сигнал [signal area_entered] из родительского класса [Area2D] с
## приватным методом [method _on_area_entered].
func _init() -> void:
	# ToDo: реализуется через функцию connect()
	pass


## Обрабатывает пересечение с [Area2D]: если [Area2D] является
## [HurtBoxInterface], то передаёт ему данные об атаке [member attack_data].
func _on_area_entered(area: Area2D) -> void:
	# ToDo: проверить, является ли area классом HurtBoxInterface (через is)
	# и воспроизвести на нём атаку (см документацию по HurtBoxInterface через
	# справку справа сверху).
	pass
