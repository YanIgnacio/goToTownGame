extends Control

@onready var music_box = $musicVolumeBox
@onready var sfx_box = $effectsVolumeBox
@onready var back_box = $back
@onready var music_btn: OptionButton = $musicVolumeBox/OptionButton
@onready var sfx_btn: OptionButton = $effectsVolumeBox/OptionButton

var screen_size: Vector2
var music_target_y: float
var sfx_target_y: float
var back_target_y: float
var offscreen_y: float

func _ready():
	screen_size = get_viewport_rect().size
	offscreen_y = screen_size.y + 200.0

	music_target_y = screen_size.y * 0.25
	sfx_target_y   = screen_size.y * 0.5
	back_target_y  = screen_size.y * 0.75

	_style_volume_btn(music_btn)
	_style_volume_btn(sfx_btn)
	
	_center_and_hide(music_box, offscreen_y)
	_center_and_hide(sfx_box, offscreen_y)
	_center_and_hide(back_box, offscreen_y)

	_populate_volume_btn(music_btn, "music_volume", 100)
	_populate_volume_btn(sfx_btn, "sfx_volume", 100)

	music_btn.get_popup().about_to_popup.connect(_on_music_about_to_popup)
	sfx_btn.get_popup().about_to_popup.connect(_on_sfx_about_to_popup)

	_animate_in()

func _style_volume_btn(btn: OptionButton):
	var popup = btn.get_popup()
	var panel = StyleBoxFlat.new()
	panel.bg_color = Color(0.851, 0.627, 0.4, 1.0)
	panel.border_width_left   = 3
	panel.border_width_right  = 3
	panel.border_width_top    = 3
	panel.border_width_bottom = 3
	panel.border_color = Color(0.0, 0.0, 0.0, 1.0)
	panel.corner_radius_top_left     = 4
	panel.corner_radius_top_right    = 4
	panel.corner_radius_bottom_left  = 4
	panel.corner_radius_bottom_right = 4
	popup.add_theme_stylebox_override("panel", panel)
	var hover = StyleBoxFlat.new()
	hover.bg_color = Color(0.82, 0.58, 0.341, 1.0)
	popup.add_theme_stylebox_override("hover", hover)
	popup.add_theme_color_override("font_color", Color(0, 0, 0))
	popup.add_theme_color_override("font_hover_color", Color(0.1, 0.1, 0.1))
	popup.add_theme_font_size_override("font_size", 24)
	var font = load("res://fonts/Minecraft.ttf")
	if font:
		popup.add_theme_font_override("font", font)
	popup.add_theme_constant_override("item_start_padding", 10)
	popup.add_theme_constant_override("item_end_padding", 10)
	popup.add_theme_constant_override("v_separation", 12)
	popup.max_size = Vector2(400, 400)

func _center_and_hide(node: Control, y: float):
	var visual_width = node.size.x * node.scale.x
	node.global_position = Vector2(
		screen_size.x / 2.0 - visual_width / 2.0,
		y
	)

func _populate_volume_btn(btn: OptionButton, save_key: String, default_val: int):
	var saved = btn.get_selected_id() if btn.item_count > 0 else default_val
	if saved == -1:
		saved = ProjectSettings.get_setting(save_key) if ProjectSettings.has_setting(save_key) else default_val

	btn.clear()

	var values = range(101)
	values.shuffle()
	for i in values:
		btn.add_item(str(i), i)

	for i in range(btn.item_count):
		if btn.get_item_id(i) == saved:
			btn.selected = i
			break
	var popup = btn.get_popup()
	popup.max_size = Vector2(400, 300)
	btn.set_meta("save_key", save_key)

func _on_music_about_to_popup():
	_populate_volume_btn(music_btn, "music_volume", 100)

func _on_sfx_about_to_popup():
	_populate_volume_btn(sfx_btn, "sfx_volume", 100)

func _animate_in():
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(music_box, "position:y", music_target_y, 0.4)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sfx_box, "position:y", sfx_target_y, 0.4)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(back_box, "position:y", back_target_y, 0.4)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _animate_out_then(callback: Callable):
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(back_box, "position:y", offscreen_y, 0.3)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(sfx_box, "position:y", offscreen_y, 0.3)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(music_box, "position:y", offscreen_y, 0.3)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_callback(callback)

func _save_volume(btn: OptionButton):
	var save_key = btn.get_meta("save_key")
	ProjectSettings.set_setting(save_key, btn.get_selected_id())

func _on_music_volume_button_item_selected(_index: int):
	_save_volume(music_btn)

func _on_effects_volume_button_item_selected(_index: int):
	_save_volume(sfx_btn)

func _on_menu_button_pressed():
	_animate_out_then(func():
		GameState.returning_from_options = true
		get_tree().change_scene_to_file("res://scenes/ui/mainMenu.tscn")
	)
