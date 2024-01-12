extends Node2D

@export var rng_seed: int = 0
@export var number_of_circles: int = 100

# @export var area_limit: Vector2 = Vector2(1000, 1000)

@export var BCircle: PackedScene

@onready var area_limit: Vector2 = get_viewport_rect().size

var background_limit_collision_shape: CollisionShape2D

var rngen: RandomNumberGenerator
var area: Area2D
var allBCircles: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	if not rngen is RandomNumberGenerator:
		rngen = RandomNumberGenerator.new()
	rngen.seed = rng_seed
	area = Area2D.new()
	area.name = "area"
	add_child(area)
	background_limit_collision_shape = CollisionShape2D.new()
	background_limit_collision_shape.shape = RectangleShape2D.new()
	background_limit_collision_shape.shape.size = area_limit
	area.add_child(background_limit_collision_shape)

	for i in range(number_of_circles):
		var circle = BCircle.instantiate()
		circle.rngen = rngen
		circle.background_limit_collision_shape = background_limit_collision_shape
		circle._reset()
		allBCircles.append(circle)
		add_child(circle)
		circle.all_bCircles = allBCircles


func _on_circle_reset_pressed():
	print("resetting circles...")
	print("number of circles: ", allBCircles.size())
	for circle in allBCircles:
		circle._reset()
