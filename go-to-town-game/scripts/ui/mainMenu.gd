extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameScene.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/optionsMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
