extends CharacterBody2D


const SPEED = 300.0
var acceleration = 1.0
const jump_speed = -400.0
var max_movement_speed = 2000.0
var max_fall_speed = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Ограничевает максимальную скорость передвежения игрока
func player_speed():
	var speed = SPEED*acceleration
	if speed < max_movement_speed:
		return speed
	else: 
		return max_movement_speed

# Ограничевает максимальную скорость падения игрока	
func fall_speed(speed):
	if speed<max_fall_speed:
		return speed
	else:
		return max_fall_speed
			

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += fall_speed(gravity * delta)

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * player_speed()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
