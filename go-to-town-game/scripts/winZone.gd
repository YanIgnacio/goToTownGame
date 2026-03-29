extends Area2D

signal game_won

func _ready():
	body_entered.connect(_on_body_entered)
	print("WinZone monitoring: ", monitoring)
	print("WinZone position: ", global_position)

func _on_body_entered(body: Node):
	print("Body entered: ", body.name, " | groups: ", body.get_groups())
	if body.is_in_group("player"):
		emit_signal("game_won")
