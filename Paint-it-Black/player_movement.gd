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
	pass


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
	# ToDo
	pass
