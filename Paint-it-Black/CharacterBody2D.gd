extends CharacterBody2D

var movement_component: BasicCharacterMovement 

func _ready():
	movement_component = $BasicCharacterMovement


func _process(delta):
	var direction = Vector2(Input.get_axis("left", "right"),0)
	movement_component.move(direction)
