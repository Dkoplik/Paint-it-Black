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

## direction - вектор направления движения
func move(direction:Vector2):
	if(direction.x):
		character_body.velocity.x = _speed(direction.x)
	else:
		character_body.velocity.x = _stop()
		
	
## вычисляет, и ограничивает скорость
## direction - направление движения по x (1/-1)
func _speed(direction):
	var velocity = character_body.velocity.x # текущая скорость персонажа по х
	velocity += movement_resource.movement_acceleration*direction
	if(abs(velocity) > movement_resource.max_movement_speed):
		return movement_resource.max_movement_speed * direction
	else: 
		return velocity

## отвечает за плавную остановку
func _stop():
	var velocity = character_body.velocity.x
	if(velocity < 0):
		if(velocity + movement_resource.movement_acceleration >=0):
			return 0
		else: 
			return velocity + movement_resource.movement_acceleration
	if(velocity > 0):
		if(velocity - movement_resource.movement_acceleration <=0):	
			return 0
		else:
			return velocity - movement_resource.movement_acceleration
	if(velocity == 0):
		return 0


func jump():
	if character_body.is_on_floor(): # простой прыжок
		character_body.velocity.y -= movement_resource.jump_speed
	if character_body.is_on_wall(): # прыжок от стены
		var wall_position = character_body.get_wall_normal()
		var jump_direction =\
		Vector2(cos(deg_to_rad(90 - movement_resource.jump_angle)) * movement_resource.jump_speed,
		sin(deg_to_rad(-90 + movement_resource.jump_angle)) * movement_resource.jump_speed) #направление прыжка
		if wall_position.x>0: # стена слева
			character_body.velocity += jump_direction
		else:
			jump_direction.x *= -1
			character_body.velocity += jump_direction


func _gravity_and_slide(delta):
	if not character_body.is_on_floor():
		if character_body.is_on_wall():  # скольжение по стене (падает медленее).
			character_body.velocity.y += movement_resource.sliding_acceleration * delta
		else:	# обычная гравитация
			character_body.velocity.y += _fall_speed(movement_resource.gravity * delta)

func _fall_speed(speed):
	if speed<movement_resource.max_fall_speed:
		return speed
