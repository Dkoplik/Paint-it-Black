extends CharacterBody2D

var movement_component: PlayerMovement
func _ready():
	movement_component = $PlayerMovement

func _process(delta):
	var direction = Vector2(Input.get_axis("left", "right"),0)
	movement_component.move(direction)
	if(Input.is_action_just_pressed("jump")):
		movement_component.jump()
