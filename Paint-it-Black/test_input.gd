extends CharacterBody2D


var _movement_component: CharacterMovementComponent 

func _ready():
	_movement_component = $CharacterMovementController

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		_movement_component.jump()	
	
	var direction = Input.get_axis("left", "right")
	
	_movement_component.move(direction, delta)	
