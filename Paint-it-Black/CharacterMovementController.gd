extends Node2D
class_name CharacterMovementComponent

signal started_idle
signal started_walking
signal started_jump
signal started_falling
signal started_sliding

@export var movement_resource: MovementResource
# узел, который двигаем
@export var character_body: CharacterBody2D


func _physics_process(delta):
	_gravity_and_slide(delta)
	character_body.move_and_slide()
	
	


func move(direction:float):
	if(direction): # если жмём на кнопку A/D, то начинаем движение
		character_body.velocity.x = lerp(character_body.velocity.x, direction * _speed(100), 0.1)
	else: # если не жмём на кнопку, т.е. останавливаемся
		if character_body.is_on_floor(): 
			character_body.velocity.x = lerp(character_body.velocity.x, 0.0, 0.15)
		else: # более плавная остановка в прыжке/полёте
			character_body.velocity.x = lerp(character_body.velocity.x, 0.0, 0.05) 
			
func jump():
	if character_body.is_on_floor(): # простой прыжок
		character_body.position.y = movement_resource.jump_speed
	if character_body.is_on_wall(): # прыжок от стены
		var wall_position = character_body.get_wall_normal()
		if wall_position.x>0: # стена слева
			character_body.position.y = movement_resource.jump_speed
			character_body.position.x -= movement_resource.jump_speed
		else: # стена справа
			character_body.position.y = movement_resource.jump_speed
			character_body.position.x = movement_resource.jump_speed

# вычисление скорости
func _speed(s:float):
	var speed = movement_resource.movement_acceleration * s
	if speed < movement_resource.max_movement_speed:
		return speed
	else: 
		return movement_resource.max_movement_speed 

func _gravity_and_slide(delta):
	if not character_body.is_on_floor():
		if character_body.is_on_wall():  # скольжение по стене (падает медленее).
			character_body.velocity.y += movement_resource.sliding_acceleration*delta
		else:	# обычная гравитация
			character_body.velocity.y += _fall_speed(movement_resource.gravity * delta)

func _fall_speed(speed):
	if speed<movement_resource.max_fall_speed:
		return speed
	else:
		return movement_resource.max_fall_speed

