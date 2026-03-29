extends Control

@onready var background: TextureRect = $MarginContainer/menuBackground
@onready var title: TextureRect = $menuTitle

static var introPlayed := false
var title_origin: Vector2

func _ready():
	title_origin = title.position

	if introPlayed:
		background.modulate.a = 1.0
		title.modulate.a = 1.0
		title.scale = Vector2(0.75, 0.75)
		title.position = Vector2(title_origin.x, title_origin.y - 250.0)
		return

	introPlayed = true
	_play_intro()

func _play_intro():
	background.modulate.a = 0.0
	title.modulate.a = 0.0
	# pivot_offset line removed — set in editor instead

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(background, "modulate:a", 1.0, 2.0)
	tween.tween_property(title, "modulate:a", 1.0, 2.0)

	tween.set_parallel(false)
	tween.tween_interval(1.0)
	tween.tween_property(title, "scale", Vector2(0.75, 0.75), 0.6)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(title, "position:y", title_origin.y - 250.0, 0.6)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameScene.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/optionsMenu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
