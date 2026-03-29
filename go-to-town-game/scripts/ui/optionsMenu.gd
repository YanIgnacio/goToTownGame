extends Control

@onready var musicVolButton = $musicVolumeBox/OptionButton
@onready var effectsVolButton = $effectsVolumeBox/OptionButton

var volumeList = []
var volumeSelected

func _ready() -> void:
	var x = 0
	while x <= 100:
		volumeList.append(x)
		x += 1
	volumeList.shuffle()
	for i in volumeList:
		musicVolButton.add_item(var_to_str(i), i)
	musicVolButton.selected = 100
	
	volumeList.shuffle()
	for i in volumeList:
		effectsVolButton.add_item(var_to_str(i), i)
	effectsVolButton.selected = 100

func _on_music_volume_button_pressed() -> void:
	musicVolButton.clear()
	volumeList.shuffle()
	for i in volumeList:
		musicVolButton.add_item(var_to_str(i), i)
	musicVolButton.show_popup()


func _on_effects_volume_button_pressed() -> void:
	effectsVolButton.clear()
	volumeList.shuffle()
	for i in volumeList:
		effectsVolButton.add_item(var_to_str(i), i)
	effectsVolButton.show_popup()


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/mainMenu.tscn")
