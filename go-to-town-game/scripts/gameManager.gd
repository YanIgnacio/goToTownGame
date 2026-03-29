extends Node2D

@onready var winScreen = $gameWon
func _ready():
	call_deferred("_connect_win_zone")

func _connect_win_zone():
	var winZone = get_tree().get_first_node_in_group("winZone")
	if winZone:
		winZone.game_won.connect(_on_game_won)
		print("WinZone connected successfully")
	else:
		print("WinZone not found!")

func _on_game_won():
	winScreen.gameFinished()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		get_tree().reload_current_scene()
