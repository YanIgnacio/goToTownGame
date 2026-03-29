extends RigidBody2D

const THRUST = 5000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		print(Vector2.RIGHT.rotated(rotation))
		apply_central_force(Vector2.RIGHT.rotated(rotation) * THRUST)
