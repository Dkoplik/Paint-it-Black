class_name Bullet
extends CustomNode2D

## Спустя какое время удалить пулю?
@export var life_time: float

## Сколько осталось до удаления.
var life_count_down: float

func _init() -> void:
	_class_name = &"Bullet"


func _ready() -> void:
	life_count_down = life_time


func _physics_process(delta):
	life_count_down -= delta
	if life_count_down <= 0.0:
		queue_free()


# Удаляет пулю после столкновения с hurt_box или твёрдым объектом.
func _delete_bullet(_object: Object) -> void:
	queue_free()
