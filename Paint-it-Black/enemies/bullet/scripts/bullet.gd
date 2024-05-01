class_name Bullet
extends CustomNode2D

## Спустя какое время удалить пулю?
@export var life_time: float
## Атакуемые группы до парирования.
@export var before_parry_hittable_groups: Array[StringName]
## Атакуемые группы после парирования.
@export var after_parry_hittable_groups: Array[StringName]
## Хитбокс снаряда.
@export var hit_box: HitBox

## Парирован ли снаряд?
var is_parried := false:
	set = set_is_parried

## Сколько осталось до удаления.
var _life_count_down: float
## Есть ли хитбокс?
var _has_hit_box := false



func _init() -> void:
	_class_name = &"Bullet"


func _ready() -> void:
	super()
	_life_count_down = life_time
	is_parried = false  # Инициализация состояния снаряда


## Проверка конфигурации узла, выполняется как в редакторе, так и в игре.
func check_configuration(_warnings: PackedStringArray = []) -> bool:
	_has_hit_box = Utilities.check_reference(hit_box, "HitBox", _warnings)
	return _has_hit_box


func _physics_process(delta):
	_life_count_down -= delta
	if _life_count_down <= 0.0:
		queue_free()


func set_is_parried(value: bool):
	is_parried = value

	if not _has_hit_box:
		push_error("У пули отсутствует hitbox")
		return

	if is_parried:
		hit_box.hittable_groups = after_parry_hittable_groups
	else:
		hit_box.hittable_groups = before_parry_hittable_groups


func switch_parried():
	is_parried = !is_parried


# Удаляет пулю после столкновения с hurt_box или твёрдым объектом.
func _delete_bullet(_object: Object) -> void:
	queue_free()
