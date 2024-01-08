extends HurtBoxInterface
class_name PlayerHurtBox
## Hurt box для игрока.
##
## Переопределяет метод [method _hurt] из родительского [HurtBoxInterface],
## чтобы задать нужное поведение реакции на входящую атаку от [BasicHitBox].


## Производит обработку входящей атаки и испускает сигнал [signal hurt]. Обычно
## вызывается компонентой [BasicHitBox] и её наследниками при пересечении с 
## данным [PlayerHurtBox].
func _hurt(attack: IncomingAttack) -> void:
	hurt.emit(attack)
	# Пока просто обработка урона
	_hp.deal_damage(attack.damage)
