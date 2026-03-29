extends CanvasLayer

var background: TextureRect

func _ready():
	layer = -1  # render behind everything
	background = TextureRect.new()
	background.texture = load("res://sprites/menuBackground.png")
	background.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

func show_background():
	background.visible = true

func hide_background():
	background.visible = false
