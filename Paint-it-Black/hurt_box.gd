extends Area2D
class_name HurtBox
## Абстрактный класс для обработки входящей атаки [Attack].
##
## Этот класс является шаблоном для других hurtbox, которые должны будут
## наследовать этот класс.


## Обрабатывает входящую атаку [param Attack].
func _process_attack(attack: Attack) -> void:
	push_error("Виртуальный метод не был переписан.")
