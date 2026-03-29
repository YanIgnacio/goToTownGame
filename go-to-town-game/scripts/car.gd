extends RigidBody2D

const TORQUE = 50.0
const JUMP_VELOCITY = 0
const MAX_SPEED = 900
var powerup_array = [stickyTires, bouncyTires, truckLid, truckRockets]
var speed = 0.0
var was_on_floor = true

@onready var frontWheel = $frontWheelPin/frontWheel
@onready var backWheel = $backWheelPin/backWheel


func _process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	clamp(speed, -20000, 20000)
	
	if direction:
		speed += TORQUE * direction
	else:
		speed = 0
		
	if not is_on_floor(frontWheel) and not is_on_floor(backWheel):
		if was_on_floor:
			speed = 0
		apply_torque(speed)
	else:
		frontWheel.apply_torque(speed)
		backWheel.apply_torque(speed)
	
	was_on_floor = not (not is_on_floor(frontWheel) and not is_on_floor(backWheel)) 
		
func _physics_process(delta):
	pass

func is_on_floor(rigidBody):
	var rayCast = rigidBody.get_parent().get_node("RayCast2D")
	return rayCast.is_colliding()
	

func activatePowerUp():
	var chosen_powerup = randi_range(0, 3)
	var powerup = powerup_array[chosen_powerup]
	print(powerup)
	pass
	
func stickyTires():
	pass
	
func bouncyTires():
	pass
	
func truckLid():
	pass
	
func truckRockets():
	pass
	
