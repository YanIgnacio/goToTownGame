extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	

func gameFinished():
	show()
	get_tree().paused = true


func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/mainMenu.tscn")
