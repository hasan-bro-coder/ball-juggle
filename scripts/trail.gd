extends Line2D

@export var target: Node2D

@export_category("Trail")
@export var max_points := 30
@export var point_distance := 8.0
@export var trail_lifetime := 0.0 # 0 = use max_points

var last_position: Vector2


func _ready():
	if target == null:
		return

	last_position = target.global_position
	clear_points()
	add_point(to_local(last_position))


func _physics_process(delta: float) -> void:
	if target == null:
		return

	var current_position := target.global_position

	# Only add a point after moving far enough
	if current_position.distance_to(last_position) >= point_distance:
		add_point(to_local(current_position))
		last_position = current_position

	# Limit trail length
	if points.size() > max_points:
		remove_point(0)
