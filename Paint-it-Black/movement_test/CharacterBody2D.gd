extends CharacterBody2D

#@export чтобы изменить в инспекторе
@export var speed = 500.0
@export var acceleration = 1.0
@export var jump_speed = -400.0
@export var max_movement_speed = 2000.0
@export var max_fall_speed = 2000.0

# Получение гравитации из настроек проекта для синхронизации с узлами RigidBody.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Ограничивает максимальную скорость передвежения игрока
func player_speed():
	var plr_speed = speed*acceleration
	if speed < max_movement_speed:
		return plr_speed
	else: 
		return max_movement_speed

# Ограничивает максимальную скорость падения игрока	
func fall_speed(speed):
	if speed<max_fall_speed:
		return speed
	else:
		return max_fall_speed
			

func _physics_process(delta):
	# Добавляет гравитацию.
	if not is_on_floor():
		velocity.y += fall_speed(gravity * delta)

	# Добавляет гравитацию.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed

	# Получение направления ввода (с клавиатуры т.е. куда пользователь хочет пойти) и обработайтка движения/замедления.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		# lerp - линейная интерполяция для более плавного передвижения
		# первый аргумент - начальная скорость, второй - конечная, третий - коэфицент перемещения от первой скорости ко второй, чем меньше, тем быстрее
		velocity.x = lerp(velocity.x, direction*player_speed(), 0.1)
	else: 
		velocity.x = lerp(velocity.x, 0.0, 0.15)

	move_and_slide()
