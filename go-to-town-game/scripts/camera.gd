extends Camera2D


@onready var player = $"../Carro"

# Called when the node enters the scene tree for the first time.
func _ready():
	position = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = $"../Carro"
	position = player.position
	pass
