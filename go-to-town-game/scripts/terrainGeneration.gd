extends Node2D

@export var chunk_width: int = 20000
@export var point_spacing: int = 16
@export var terrain_height: float = 500.0
@export var noise_frequency: float = 0.005
@export var flat_spawn_length: float = 1000.0
@export var city_length: float = 2000.0
@export var transition_length: float = 400.0
@export var camera: Camera2D

var noise := FastNoiseLite.new()

# City sits at the end of the level
var city_start: float
var city_end: float

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_frequency
	noise.seed = randi()

	# Place city at the end of the chunk
	city_end = chunk_width
	city_start = city_end - city_length

	generate_terrain()

func get_height(x: float) -> float:
	# Flat spawn zone
	if x < flat_spawn_length:
		return 0.0

	# Transition from spawn into terrain
	if x < flat_spawn_length + transition_length:
		var t = (x - flat_spawn_length) / transition_length
		return lerp(0.0, noise.get_noise_1d(x) * terrain_height, t)

	# Transition into city
	if x >= city_start - transition_length and x < city_start:
		var t = (x - (city_start - transition_length)) / transition_length
		return lerp(noise.get_noise_1d(x) * terrain_height, 0.0, t)

	# City flat floor
	if x >= city_start and x <= city_end:
		return 0.0

	# Normal terrain between spawn and city
	return noise.get_noise_1d(x) * terrain_height

func smooth(points: Array, passes: int) -> Array:
	for _p in range(passes):
		for i in range(2, points.size() - 2):
			var x = points[i].x
			# Skip flat zones so they stay perfectly flat
			if x < flat_spawn_length:
				continue
			if x >= city_start and x <= city_end:
				continue
			points[i].y = (
				points[i - 2].y * 0.1 +
				points[i - 1].y * 0.25 +
				points[i].y    * 0.3  +
				points[i + 1].y * 0.25 +
				points[i + 2].y * 0.1
			)
	return points

func generate_terrain():
	var num_points: int = int(chunk_width / float(point_spacing))
	var raw_points := []

	for i in range(num_points):
		var x = i * point_spacing
		raw_points.append(Vector2(x, get_height(x)))

	raw_points = smooth(raw_points, 40)

	# Collision
	var segments := PackedVector2Array()
	for i in range(raw_points.size() - 1):
		segments.append(raw_points[i])
		segments.append(raw_points[i + 1])

	var shape := ConcavePolygonShape2D.new()
	shape.segments = segments
	$StaticBody2D/CollisionShape2D.shape = shape

	# Polygon2D fill
	var points := PackedVector2Array()
	for p in raw_points:
		points.append(p)
	points.append(Vector2(raw_points[-1].x, 1000.0))
	points.append(Vector2(raw_points[0].x, 1000.0))
	$Polygon2D.polygon = points

	# Line2D surface
	var surface := PackedVector2Array()
	for p in raw_points:
		surface.append(p)
	$Line2D.points = surface
	
	var win_zone_x = city_start + city_length * 0.5
	var win_zone_y = get_height(win_zone_x)
	$WinZone.global_position = Vector2(win_zone_x - 200, win_zone_y)

	var rect := RectangleShape2D.new()
	rect.size = Vector2(200, 4000)
	$WinZone/CollisionShape2D.shape = rect

	print("WinZone bounds: ", $WinZone.global_position, " size: ", rect.size)
