extends BasicCharacterMovement
class_name PlayerMovement
## Этот класс отвечает за движение игрока.
##
## Эта компонента содержит реализацию прыжка, скольжения по стенам и прыжка от
## стен для игрока. В качестве параметров используются данные из
## [PlayerMovementData].

## Испускается, когда игрок совершил прыжок.
signal started_jump
## Испускается, когда игрок начал скользить по стене.
signal started_sliding


func _ready() -> void:
	# ToDo: проверка наличия movement_data и chracter_body. То есть, они должны
	# быть не null, иначе компонент не будет работать. По этому проверку
	# выполнять в assert, чтобы программа прерывалась.
	# Более того, нужно проверить, что movement_data не просто
	# BasicMovementData, а именно PlayerMovementData (проверить через is).
	assert(movement_data != null and character_body != null)
	## проверка на то, что мы используем ресурсы игрока, а не что-то иное.
	assert(movement_data is PlayerMovementData)


func _process(delta):
	# ToDo обработку прочего движения, например, скольжения по стене. При этом
	# каждую такую обработку делать в отдельной приватной функции (не забыть про
	# документирующие комментарии). Также не забыть вызвать все приватные
	# функции из родительского класса BasicCharacterMovement.
	pass


## Осуществляет прыжок игрока, причём как обычный, так и от стен, и испускает
## сигнал [signal started_jump]. Если игрок не находится ни на полу, ни на
## стене, то метод ничего не делает. Если игрок на полу, то он получает
## начальную вертикальную скорость [member PlayerMovementData.jump_speed],
## если на стене, то учитывается ещё параметр
## [member PlayerMovementData.jump_angle].
func jump() -> void:
	if character_body.is_on_floor(): # простой прыжок
		character_body.velocity.y -= movement_data.jump_speed
	if character_body.is_on_wall(): # прыжок от стены
		var wall_position = character_body.get_wall_normal()
		var jump_direction =\
		Vector2(cos(deg_to_rad(90 - movement_data.jump_angle)) * movement_data.jump_speed,
		sin(deg_to_rad(-90 + movement_data.jump_angle)) * movement_data.jump_speed) #направление прыжка
		if wall_position.x>0: # стена слева
			character_body.velocity += jump_direction
		else:
			jump_direction.x *= -1
			character_body.velocity += jump_direction
