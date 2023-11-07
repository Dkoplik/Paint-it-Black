extends CharacterBody2D


var _movement_component: CharacterMovementComponent 

func _ready():
	_movement_component = $CharacterMovementController

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		_movement_component.jump()	
	
	var direction = Vector2(Input.get_axis("left", "right"), 0)
	_movement_component.move(direction)	
