@tool
extends CharacterBody2D

## Данные о жизнях
@export var hp_data: Resource # ToDo: пока нет ресурса под жизни
## Данные движения
@export var movement_data: PlayerMovementData
## Данные об атаке
@export var attack_data: PlayerAttackData

## Компонента движения
var movement_component: PlayerMovement
## Компонента атаки
var attack_component: PlayerAttack
## HitBox
var hit_box # ToDo добавить тип, когда будет
## HurtBox
var hurt_box: PlayerHurtBox


func _ready():
	# Проверка наличия компонент
	_check_movement_component()
	_check_attack_component()
	_check_hit_box_component()
	_check_hurt_box_component()
	
	# Проверка наличия данных
	#_check_hp_data() пока отсутствует
	_check_movement_data()
	_check_attack_data()


## Обработка управления
func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		var direction = Vector2.ZERO
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		movement_component.move(direction)


## Обработка прыжка и атаки
func _unhandled_input(event):
	if not Engine.is_editor_hint():
		# Прыжок
		if event.is_action_pressed("jump"):
			movement_component.jump()
		# Атака
		if event.is_action_pressed("attack"):
			attack_component.attack(get_viewport().get_mouse_position()
			- position)


## Обработка ошибок конфигурации
func _get_configuration_warnings() -> PackedStringArray:
	# Ошибки конфигурации
	var warnings: PackedStringArray = []
	
	# Проверка наличия компонент
	_check_movement_component(warnings)
	_check_attack_component(warnings)
	_check_hit_box_component(warnings)
	_check_hurt_box_component(warnings)
	
	# Проверка наличия данных
	_check_hp_data(warnings)
	_check_movement_data(warnings)
	_check_attack_data(warnings)
	
	return warnings


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
	print(1)
	return hurt_box


## Проверяет наличие единственной компоненты движения и передаёт все необходимые
## данные от этого узла компоненте.
func _check_movement_component(warnings: PackedStringArray = []) -> void:
	var movement_components: Array =\
		get_children().filter(func(node): return node is PlayerMovement)
	
	if movement_components.size() > 1:
		if Engine.is_editor_hint():
			warnings.push_back("Обнаружено несколько компонент PlayerMovement")
		else:
			assert(false, "Обнаружено несколько компонент PlayerMovement")
		movement_component = null
	elif movement_components.size() == 0:
		if Engine.is_editor_hint():
			warnings.push_back("Не найдена компонента PlayerMovement")
		else:
			assert(false, "Не найдена компонента PlayerMovement")
		movement_component = null
	else:
		movement_component = movement_components[0] as PlayerMovement
		movement_component.movement_data = movement_data


## Находит компоненту атаки среди дочерних узлов
func _check_attack_component(warnings: PackedStringArray = []) -> void:
	var attack_components: Array =\
		get_children().filter(func(node): return node is PlayerAttack)
	
	if attack_components.size() > 1:
		if Engine.is_editor_hint():
			warnings.push_back("Обнаружено несколько компонент PlayerMovement")
		else:
			assert(false, "Обнаружено несколько компонент PlayerMovement")
		attack_component = null
	elif attack_components.size() == 0:
		if Engine.is_editor_hint():
			warnings.push_back("Не найдена компонента PlayerMovement")
		else:
			assert(false, "Не найдена компонента PlayerMovement")
		attack_component = null
	else:
		attack_component = attack_components[0] as PlayerAttack
		attack_component.attack_data = attack_data


## Находит компоненту hitbox среди дочерних узлов
func _check_hit_box_component(warnings: PackedStringArray = []) -> void:
	pass #ToDo


## Проверяет наличие единственной компоненты hurtbox и передаёт все необходимые
## данные от этого узла компоненте.
func _check_hurt_box_component(warnings: PackedStringArray = []) -> void:
	var hurt_box_components: Array =\
		get_children().filter(func(node): return node is PlayerHurtBox)
	
	if hurt_box_components.size() > 1:
		if Engine.is_editor_hint():
			warnings.push_back("Обнаружено несколько компонент PlayerHurtBox")
		else:
			assert(false, "Обнаружено несколько компонент PlayerHurtBox")
		hurt_box = null
	elif hurt_box_components.size() == 0:
		if Engine.is_editor_hint():
			warnings.push_back("Не найдена компонента PlayerHurtBox")
		else:
			assert(false, "Не найдена компонента PlayerHurtBox")
		hurt_box = null
	else:
		hurt_box = hurt_box_components[0]
	
	# ToDo, компоненте HP передать ресурс HP


## Проверка наличия данных о hp
func _check_hp_data(warnings: PackedStringArray = []) -> void:
	if hp_data ==  null:
		if Engine.is_editor_hint():
			warnings.push_back("Не обнаружена HPData")
		else:
			assert(false, "Не обнаружена HPData")


## Проверка наличия данных о движении
func _check_movement_data(warnings: PackedStringArray = []) -> void:
	if movement_data ==  null:
		if Engine.is_editor_hint():
			warnings.push_back("Не обнаружена PlayerMovementData")
		else:
			assert(false, "Не обнаружена PlayerMovementData")


## Проверка наличия данных об атаке
func _check_attack_data(warnings: PackedStringArray = []) -> void:
	if attack_data ==  null:
		if Engine.is_editor_hint():
			warnings.push_back("Не обнаружена PlayerAttackData")
		else:
			assert(false, "Не обнаружена PlayerAttackData")
