extends Node2D

@export var flat_spawn_length: int = 1000
@export var chunk_width: int = 20000
@export var point_spacing: int = 16
@export var terrain_height: float = 500.0
@export var noise_frequency: float = 0.005  # lower for smoother hills
@export var camera: Camera2D

var noise := FastNoiseLite.new()
var generated_up_to: float = 0.0


func _ready():
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_frequency
	noise.seed = randi()
	generate_terrain(0)
	generated_up_to = chunk_width

func get_height(x: float) -> float:
	if x < flat_spawn_length:
		return 0.0
	if x < flat_spawn_length + 200:
		var t = (x - flat_spawn_length) / 200.0  # 0.0 to 1.0
		return lerp(0.0, noise.get_noise_1d(x) * terrain_height, t)
	return noise.get_noise_1d(x) * terrain_height

func smooth(points: Array, passes: int) -> Array:
	for _p in range(passes):
		for i in range(2, points.size() - 2):
			points[i].y = (
				points[i - 2].y * 0.1 +
				points[i - 1].y * 0.25 +
				points[i].y    * 0.3  +
				points[i + 1].y * 0.25 +
				points[i + 2].y * 0.1
			)
	return points

func generate_terrain(start_x: float):
	var num_points: int = int(chunk_width / float(point_spacing))

	var raw_points := []
	for i in range(num_points):
		var x = start_x + i * point_spacing
		raw_points.append(Vector2(x, get_height(x)))

	raw_points = smooth(raw_points, 40)

	var segments := PackedVector2Array()
	for i in range(raw_points.size() - 1):
		segments.append(raw_points[i])
		segments.append(raw_points[i + 1])

	var shape := ConcavePolygonShape2D.new()
	shape.segments = segments
	$StaticBody2D/CollisionShape2D.shape = shape

	var points := PackedVector2Array()
	for p in raw_points:
		points.append(p)
	points.append(Vector2(raw_points[-1].x, 1000.0))
	points.append(Vector2(raw_points[0].x, 1000.0))
	$Polygon2D.polygon = points

	# Line2D surface (grass strip)
	var surface := PackedVector2Array()
	for p in raw_points:
		surface.append(p)
	$Line2D.points = surface

func _process(_delta):
	if camera == null:
		return
	var cam_x = camera.global_position.x
	if cam_x + 1200 > generated_up_to:
		generate_terrain(generated_up_to)
		generated_up_to += chunk_width
