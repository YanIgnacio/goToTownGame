extends Control

@onready var titleAnchor: Node2D = $titleAnchor
@onready var startBtn = $Start
@onready var optionsBtn = $Options
@onready var quitBtn = $Quit

var origin_y: float

func _ready():
	var screen = get_viewport_rect().size
	titleAnchor.position = Vector2(screen.x / 2.0, screen.y / 2.0)
	origin_y = titleAnchor.position.y

	startBtn.modulate.a = 0.0
	optionsBtn.modulate.a = 0.0
	quitBtn.modulate.a = 0.0

	if GameState.returning_from_options:
		GameState.returning_from_options = false
		_restore_final_state()
		_fade_in_all()
		return

	if GameState.intro_played:
		_restore_final_state()
		_show_buttons_instant()
		return

	GameState.intro_played = true
	_play_intro()

func _restore_final_state():
	titleAnchor.modulate.a = 0.0
	titleAnchor.scale = Vector2(0.75, 0.75)
	titleAnchor.position.y = origin_y - 250.0
	_position_buttons()

func _fade_in_all():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(titleAnchor, "modulate:a", 1.0, 0.6)
	tween.tween_property(startBtn, "modulate:a", 1.0, 0.6)
	tween.tween_property(optionsBtn, "modulate:a", 1.0, 0.6)
	tween.tween_property(quitBtn, "modulate:a", 1.0, 0.6)

func _fade_out_all_then(callback: Callable):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(titleAnchor, "modulate:a", 0.0, 0.4)
	tween.tween_property(startBtn, "modulate:a", 0.0, 0.4)
	tween.tween_property(optionsBtn, "modulate:a", 0.0, 0.4)
	tween.tween_property(quitBtn, "modulate:a", 0.0, 0.4)
	tween.set_parallel(false)
	tween.tween_callback(callback)

func _play_intro():
	titleAnchor.modulate.a = 0.0

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(titleAnchor, "modulate:a", 1.0, 2.0)
	tween.set_parallel(false)
	tween.tween_interval(1.0)
	tween.tween_property(titleAnchor, "scale", Vector2(0.75, 0.75), 0.6)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(titleAnchor, "position:y", origin_y - 250.0, 0.6)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_position_buttons)
	tween.set_parallel(true)
	tween.tween_property(startBtn, "modulate:a", 1.0, 0.5)
	tween.tween_property(optionsBtn, "modulate:a", 1.0, 0.5)
	tween.tween_property(quitBtn, "modulate:a", 1.0, 0.5)

func _position_buttons():
	var screen = get_viewport_rect().size
	var options_visual_width = optionsBtn.size.x * optionsBtn.scale.x
	var btn_y = (origin_y - 250.0) + 43
	optionsBtn.global_position = Vector2(screen.x / 2.0 - options_visual_width / 2.0, btn_y)
	var mid_y = screen.y / 2.0 + 50.0
	startBtn.global_position = Vector2(startBtn.global_position.x, mid_y)
	quitBtn.global_position = Vector2(quitBtn.global_position.x, mid_y)

func _show_buttons_instant():
	titleAnchor.modulate.a = 1.0
	startBtn.modulate.a = 1.0
	optionsBtn.modulate.a = 1.0
	quitBtn.modulate.a = 1.0

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/gameScene.tscn")

func _on_settings_button_pressed():
	_fade_out_all_then(func():
		get_tree().change_scene_to_file("res://scenes/ui/optionsMenu.tscn")
	)

func _on_quit_button_pressed():
	get_tree().quit()
