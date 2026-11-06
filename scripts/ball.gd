extends CharacterBody2D
class_name Ball

@export var upward_impulse_scale := 10.0

@export var max_speed := 100000.0
@export var air_friction := 0.008

@onready var star: Sprite2D = $Star
@onready var sprite: Sprite2D = $Sprite2D
@export var bounce := 0.9
@onready var bounce_audio: AudioStreamPlayer = $bounce
@onready var floor_hit_audio: AudioStreamPlayer = $floor_hit
@onready var ground_ray: RayCast2D = $GroundRay
var angular_velocity := 50
#func launch(power: float, direction: Vector2) -> void:
	#var impulse := direction.normalized() * power * upward_impulse_scale
	#linear_velocity = impulse
	#apply_central_impulse(impulse)
	
func _ready() -> void:
	velocity = Vector2(30,0)

var was_on_floor = false
func launch(power: float, direction: Vector2,hit_pos:Vector2) -> void:
	#print(power,direction)
	#var theta := deg_to_rad(randi_range(135,45))
	velocity.x = (direction * power).x
	velocity.y = -power
	#abs((direction * power).y)
	star.global_position = hit_pos
	#star.show()
	#direction.y = -abs(direction.y) * 300
	#velocity.x += direction.x
	#.normalized()
	#velocity.y = direction.y
	was_on_floor = false
	angular_velocity = 2 * power
	

func _physics_process(delta: float) -> void:
	# Air friction
	
	velocity *= 1.0 / (1.0 + air_friction)
	sprite.rotation_degrees += angular_velocity * delta
	angular_velocity *= 0.99
	if not ground_ray.is_colliding():
		if velocity.y < 500:
			velocity.y += 6.8
		pass
	else:
		var col = ground_ray.get_collider()
		print("GROUND RAY:",col)
		angular_velocity *= 0.80
		if was_on_floor == false:
			floor_hit_audio.play()
			StateHandler.add_kick(-StateHandler.kick_count)
			Global.show_label(global_position,"CHOCKED")
			was_on_floor = true
			
		#var theta := deg_to_rad(randi_range(135,45))
		#velocity = Vector2(cos(theta),-sin(theta)) * 5F00F
		#velocity.y = 0
	# Speed limit
	#if velocity.length() > max_speed:
		#velocity = velocity.normalized() * max_speed


	# Bounce from collisions
	#print(velocity)
	if velocity.length() < 0.1:
		velocity = Vector2.ZERO
	var collision := move_and_collide(velocity * delta)
	if !collision:
		return
	bounce_audio.play()
	velocity = velocity.bounce(collision.get_normal()) * 0.95


var ring_radius := 16
var ring_duration := 0.25
var ring_expand := 16
func create_ring(power: float):
	var ring := Line2D.new()

	ring.width = lerp(2.0, 4.0, power)
	ring.default_color = Color.WHITE
	ring.closed = true
	ring.z_index = 10

	var points := 24

	for i in points:
		var angle := TAU * float(i) / points
		ring.add_point(
			Vector2(cos(angle), sin(angle)) * ring_radius
		)

	add_child(ring)

	var tween := create_tween()

	tween.set_parallel(true)

	tween.tween_method(
		func(radius: float):
			for i in points:
				var angle := TAU * float(i) / points
				ring.set_point_position(
					i,
					Vector2(cos(angle), sin(angle)) * radius
				),
		ring_radius,
		ring_radius + ring_expand * power,
		ring_duration
	)

	tween.tween_property(
		ring,
		"modulate:a",
		0.0,
		ring_duration
	)

	tween.chain().tween_callback(ring.queue_free)

func _on_hit_timer_timeout() -> void:
	pass 
