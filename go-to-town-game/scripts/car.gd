extends RigidBody2D

const TORQUE = 10000.0
const FRICTION = 10
const JUMP_VELOCITY = 0
const MAX_SPEED = 900

@onready var frontWheel = $frontWheelPin/frontWheel
@onready var backWheel = $backWheelPin/backWheel

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		frontWheel.apply_torque(direction * TORQUE)
		backWheel.apply_torque(direction * TORQUE)
