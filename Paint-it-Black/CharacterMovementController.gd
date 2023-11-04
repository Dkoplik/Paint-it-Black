extends Node2D

signal started_idle
signal started_walking
signal started_jump
signal started_falling
signal started_sliding

@export var movement_resource: MovementResource
# узел, который двигаем
@export var character_body: CharacterBody2D


func _physics_process(delta):
	move(movement_resource.Input.get_axis("left", "right"))
	jump()

func move(direction:Vector2):
	if(direction):
		character_body.position.x = lerp(character_body.position.x, direction * _speed(100), 0.1)
	else: # если не жмём на кнопку, т.е. останавливаемся
		if character_body.is_on_floor(): 
			character_body.position.x = lerp(character_body.position.x, 0.0, 0.15)

func jump():
	if Input.is_action_just_pressed("ui_accept"): 
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



