extends Area2D

@export var radius = 5
@export var color = Color.WHITE
@export var direction = Vector2(0, 0)
@export var speed_range = Vector2(-100, 100)
@export var max_lenght_line = 180

var background_limit_collision_shape: CollisionShape2D
var rngen: RandomNumberGenerator
var collision_shape: CollisionShape2D

var nearby_bCircles: Array = []
var all_bCircles: Array = []


func _on_area_entered(area):
	if all_bCircles.has(area):
		nearby_bCircles.append(area)


func _on_area_exited(area):
	if all_bCircles.has(area):
		if to_local(area.position).length() > max_lenght_line + area.radius:
			nearby_bCircles.erase(area)


func _ready():
	collision_shape = CollisionShape2D.new()
	add_child(collision_shape)
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = radius
	collision_shape.shape = circle_shape
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)


func _get_rngen() -> RandomNumberGenerator:
	if rngen == null:
		rngen = RandomNumberGenerator.new()
		rngen.randomize()
	return rngen


func _reset():
	rngen = _get_rngen()
	position = (
		Vector2(rngen.randf_range(-1, 1), rngen.randf_range(-1, 1)).normalized()
		* (background_limit_collision_shape.shape.get_rect().size / 2).rotated(
			rngen.randf_range(-PI, PI)
		)
	)
	direction = (
		Vector2(rngen.randf_range(0.1, 1), rngen.randf_range(-1, 1)).normalized()
		* Vector2(
			rngen.randi_range(speed_range.x, speed_range.y),
			rngen.randi_range(speed_range.x, speed_range.y)
		)
	)


func _draw():
	for nearby_bcircle in nearby_bCircles:
		if nearby_bcircle == self:
			continue
		var to_pos = to_local(nearby_bcircle.position)
		var dist = to_pos.length()
		var max_dist = radius + nearby_bcircle.radius + max_lenght_line
		if dist > max_dist:
			continue
		var c: Color = color
		c.a = 1.0 - dist / max_dist
		c.a = absf(c.a - .2)
		draw_line(Vector2(0, 0), to_pos / 2, c, 2)

	draw_circle(Vector2(0, 0), radius, color)


func _process(delta):
	position += direction * delta

	if position.x < -background_limit_collision_shape.shape.get_rect().size.x / 2:
		position.x = -background_limit_collision_shape.shape.get_rect().size.x / 2
		direction.x *= -1 * rngen.randf_range(0.5, 1.5)
		direction.y *= rngen.randf_range(0.5, 1.5)

	elif position.x > background_limit_collision_shape.shape.get_rect().size.x / 2:
		position.x = background_limit_collision_shape.shape.get_rect().size.x / 2
		direction *= -1 * rngen.randf_range(0.5, 1.5)
		direction.y *= rngen.randf_range(0.5, 1.5)

	if position.y < -background_limit_collision_shape.shape.get_rect().size.y / 2:
		position.y = -background_limit_collision_shape.shape.get_rect().size.y / 2
		direction.y *= -1 * rngen.randf_range(0.5, 1.5)
		direction.x *= rngen.randf_range(0.5, 1.5)

	elif position.y > background_limit_collision_shape.shape.get_rect().size.y / 2:
		position.y = background_limit_collision_shape.shape.get_rect().size.y / 2
		direction.y *= -1 * rngen.randf_range(0.5, 1.5)
		direction.x *= rngen.randf_range(0.5, 1.5)

	queue_redraw()
