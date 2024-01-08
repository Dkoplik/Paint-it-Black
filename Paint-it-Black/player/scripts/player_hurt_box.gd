class_name PlayerHurtBox
extends HurtBoxInterface
## Hurt box для игрока.
##
## Переопределяет метод [method _hurt] из родительского [HurtBoxInterface],
## чтобы задать нужное поведение реакции на входящую атаку от [BasicHitBox].


## Производит обработку входящей атаки и испускает сигнал [signal was_hurt].
## Обычно вызывается компонентой [BasicHitBox] и её наследниками при пересечении
## с данным [PlayerHurtBox].
func hurt(attack: IncomingAttack) -> void:
	was_hurt.emit(attack)
	# Пока просто обработка урона
	_hp.deal_damage(attack.damage)
