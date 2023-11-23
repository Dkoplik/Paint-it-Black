extends CharacterBody2D

## Данные о жизнях
@export var hp_data: Resource # ToDo: пока нет ресурса под жизни
## Данные движения
@export var movement_data: PlayerMovementData
## Данные об атаке
@export var attack_data: AttackData
## Длительность атаки
@export_range(0, 1, 0.01, "or_greater") var attack_duration: float
## Время между атаками
@export_range(0, 5, 0.01, "or_greater") var attack_cooldown: float

## Компонента движения
var movement_component: PlayerMovement
## Компонента атаки
var attack_component # ToDo добавить тип, когда появиться
## HitBox
var hit_box # ToDo добавить тип, когда будет
## HurtBox
var hurt_box: PlayerHurtBox


## Проверка всех необходимых компонент
func _ready() -> void:
	_check_movement_component()
	_check_attack_component()
	_check_hit_box_component()
	_check_hurt_box_component()


## Обработка управления
func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	movement_component.move(direction)


## Обработка прыжка
func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		movement_component.jump()


## Возвращает компоненту движения игрока
func get_movement_component() -> PlayerMovement:
	return movement_component


## Возвращает компоненту атаки игрока
func get_attack_component():
	pass # ToDo, добавить компоненту атаки, когда будет готова


## Возвращает hitbox игрока
func get_hit_box_component():
	pass # ToDo когда появиться хитбокс


## Возвращает hurtbox игрока
func get_hurt_box_component() -> PlayerHurtBox:
	return hurt_box


## Находит компоненту движения среди дочерних узлов
func _check_movement_component() -> void:
	for node in get_children():
		if node is PlayerMovement:
			assert(movement_component == null,
			"Обнаружено несколько компонент движения")
			movement_component = node as PlayerMovement
	assert(movement_component != null, "Не найдена компонента движения")
	
	movement_component.movement_data = movement_data


## Находит компоненту атаки среди дочерних узлов
func _check_attack_component() -> void:
	pass #ToDo


## Находит компоненту hitbox среди дочерних узлов
func _check_hit_box_component() -> void:
	pass #ToDo


## Находит компоненту hurtbox среди дочерних узлов
func _check_hurt_box_component() -> void:
	for node in get_children():
		if node is PlayerHurtBox:
			assert(hurt_box == null, "Обнаружено несколько hurtbox'ов")
			hurt_box = node as PlayerHurtBox
	assert(hurt_box != null, "Не найден hurtbox")
	
	# ToDo, компоненте HP передать ресурс HP
