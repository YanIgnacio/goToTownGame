extends RigidBody2D

const TORQUE = 50.0
const JUMP_VELOCITY = 0
const MAX_SPEED = 900
const THRUST = 1000
var powerup_array = [stickyTires, bouncyTires, truckLid, truckRockets]
var speed = 0.0
var wasOnFloor = true
var stickyTiresActive = false
var bouncyTiresActive = false
var truckLidActive = false

@onready var timer = $timer
@onready var frontWheel = $frontWheelPin/frontWheel
@onready var backWheel = $backWheelPin/backWheel
@onready var rocket = $rocket
@onready var lid = $truckLid

func _process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	clamp(speed, -20000, 20000)
	
	if direction:
		speed += TORQUE * direction
	else:
		speed = 0
		
	if not is_on_floor(frontWheel) and not is_on_floor(backWheel):
		if wasOnFloor:
			speed = 0
		apply_torque(speed)
	else:
		frontWheel.apply_torque(speed)
		backWheel.apply_torque(speed)
		
	if rocket.visible:
		apply_central_force(Vector2.RIGHT.rotated(rotation) * THRUST)

	
	wasOnFloor = not (not is_on_floor(frontWheel) and not is_on_floor(backWheel))
		
func _physics_process(delta):
	if stickyTiresActive:
		stickyTires()

func is_on_floor(rigidBody):
	var rayCast = rigidBody.get_parent().get_node("RayCast2D")
	return rayCast.is_colliding()
	

func activatePowerUp():
	var chosen_powerup = randi_range(0, 3)
	var powerup = powerup_array[chosen_powerup]
	powerup.call()
	timer.start()
	
	
func stickyTires():
	stickyTiresActive = true
	var downforce = Vector2.DOWN * 2000
	frontWheel.apply_central_force(downforce)
	backWheel.apply_central_force(downforce)
	
func bouncyTires():
	frontWheel.physics_material_override.bounce = 1.0
	backWheel.physics_material_override.bounce = 1.0
	frontWheel.physics_material_override.absorbent = false
	backWheel.physics_material_override.absorbent = false
	
func truckLid():
	lid.visible = true
	lid.get_node("CollisionShape2D").set_deferred('disabled', false)
	pass
	
func truckRockets():
	rocket.visible = true
	pass
	

func _on_timer_timeout():
	stickyTiresActive = false
	bouncyTiresActive = false
	truckLidActive = false
	rocket.visible = false
	lid.visible = false
	lid.get_node("CollisionShape2D").set_deferred('disabled', true)
