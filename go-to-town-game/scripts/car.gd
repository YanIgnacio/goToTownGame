extends RigidBody2D

const SPEED = 3000.0
const FRICTION = 10
const JUMP_VELOCITY = 0
const MAX_SPEED = 900

@onready var frontWheel = $frontWheel
@onready var backWheel = $backWheel

func _ready():
	frontWheel.apply_torque(10000)

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		frontWheel.apply_torque(direction * SPEED)
		backWheel.apply_torque(direction * SPEED)
