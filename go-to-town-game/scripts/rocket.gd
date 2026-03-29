extends RigidBody2D

const THRUST = 500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_central_force(Vector2.RIGHT.rotated(rotation) * THRUST)
	pass
