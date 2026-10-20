#extends Node2D
#class_name PathPreview
#
#@export var dot_radius := 1.5
#@export var base_spacing := 8.0
#@export var spacing_power_scale := 0.015
#
#var start_position := Vector2.ZERO
#var launch_velocity := Vector2.ZERO
#var gravity := 600.0
#var preview_enabled := false
#
#
#func update_path(
	#start: Vector2,
	#initial_velocity: Vector2,
	#rabbit_gravity: float
#) -> void:
	#start_position = start
	#launch_velocity = initial_velocity
	#gravity = rabbit_gravity
	#preview_enabled = true
	#queue_redraw()
#
#
#func hide_path() -> void:
	#preview_enabled = false
	#queue_redraw()
#
#
#func _draw() -> void:
	#if not preview_enabled:
		#return
#
	#var spacing := base_spacing + launch_velocity.length() * spacing_power_scale
	#var screen_size := get_viewport_rect().size
#
	#var t := 0.0
	#var previous_point := start_position
#
	#while t < 5.0:
		#var point := start_position \
			#+ launch_velocity * t \
			#+ Vector2.DOWN * (0.5 * gravity * t * t)
#
		#if t > 0.0:
			#var distance := previous_point.distance_to(point)
#
			#if distance >= spacing:
				#draw_circle(to_local(point), dot_radius, Color.WHITE)
				#previous_point = point
#
		## Stop when outside screen
		#if point.x < 0 or point.x > screen_size.x \
		#or point.y < 0 or point.y > screen_size.y:
			#break
#
		#t += 0.016
		

extends Node2D
class_name PathPreview

@export var dot_count := 25
@export var time_step := 0.08
@export var dot_radius := 3.0
@export var dot_spacing_scale := 1.0

var start_position := Vector2.ZERO
var launch_velocity := Vector2.ZERO
var gravity := 600.0
var preview_enabled := false


func update_path(
	start: Vector2,
	initial_velocity: Vector2,
	rabbit_gravity: float
) -> void:
	start_position = start
	launch_velocity = initial_velocity
	gravity = rabbit_gravity
	preview_enabled = true
	queue_redraw()


func hide_path() -> void:
	preview_enabled = false
	queue_redraw()


func _draw() -> void:
	if not preview_enabled:
		return

	for i in range(1, dot_count + 1):
		var t := i * time_step * dot_spacing_scale

		# Simulate projectile motion
		var point := start_position \
			+ launch_velocity * t \
			+ Vector2.DOWN * (0.5 * gravity * t * t)
		var percent: float = (dot_count * 2 - i)/float(dot_count * 2)
		draw_circle(to_local(point), dot_radius, Color(1.0, 1.0, 1.0, 1.0 * percent))
