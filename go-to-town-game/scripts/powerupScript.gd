extends Area2D

func _on_body_entered(body):
	if body.name == 'car':
		body.activatePowerUp()
		
		get_parent().queue_free()
		
	
