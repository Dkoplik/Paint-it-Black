extends CharacterBody2D

#@export чтобы изменить в инспекторе
@export var speed = 500.0
@export var acceleration = 1.0
@export var jump_speed = -700.0
@export var max_movement_speed = 2000.0
@export var max_fall_speed = 2000.0
@export var gravity = 2000
@export var sliding_acceleration = 1000
@export var max_sliding_speed = 1000


func _physics_process(delta):
	# Добавляет гравитацию.
	if not is_on_floor():
		if is_on_wall():  # скольжение по стене (падает медленее).
			velocity.y += sliding_acceleration*delta
		else:	# обычная гравитация
			velocity.y += fall_speed(gravity * delta)

	# Прыжок.
	if Input.is_action_just_pressed("ui_accept"): 
		if is_on_floor(): # простой прыжок
			velocity.y = jump_speed
		if is_on_wall(): # прыжок от стены
			var wall_position = get_wall_normal()
			if wall_position.x>0: # стена слева
				velocity.y = jump_speed
				velocity.x -= jump_speed
			else:
				velocity.y = jump_speed
				velocity.x = jump_speed

	# Получение направления ввода (с клавиатуры т.е. куда пользователь хочет пойти) и обработайтка движения/замедления.
	var direction = Input.get_axis("left", "right")
	if direction: # если жмём на кнопку (начинаем движение)
		velocity.x = lerp(velocity.x, direction*player_speed(), 0.1) # lerp - линейная интерполяция для более плавного передвижения. первый аргумент - начальная скорость, второй - конечная, третий - коэфицент перемещения от первой скорости ко второй, чем меньше, тем плавнее
	else: # если не жмём на кнопку, т.е. останавливаемся
		if is_on_floor(): 
			velocity.x = lerp(velocity.x, 0.0, 0.15)
		else: 
			velocity.x = lerp(velocity.x, 0.0, 0.05) #более плавная остановка в прыжке	
	move_and_slide()

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
