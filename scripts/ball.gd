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
	velocity.x += (direction * power).x
	velocity.y = -abs((direction * power).y)
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
	if not ground_ray.is_colliding() and velocity.y < 500:
		velocity.y += 6.8
		pass
	else:
		angular_velocity *= 0.80
		if was_on_floor == false:
			floor_hit_audio.play()
			StateHandler.add_kick(-StateHandler.kick_count)
			#get_tree().paused = true
			#await get_tree().create_timer(0.5).timeout
			#get_tree().paused = false
			was_on_floor = true
		#var theta := deg_to_rad(randi_range(135,45))
		#velocity = Vector2(cos(theta),-sin(theta)) * 500
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

	#*0.95
	#for i in get_slide_collision_count():
		#var collision := get_slide_collision(i)
		#var normal := collision.get_normal()
		#print(collision,normal,velocity,velocity.bounce(normal))
#
		## Reflect velocity around collision normal
		#velocity = velocity.bounce(normal) * 2

#func _physics_process(delta: float) -> void:
	#ground_ray.global_position = global_position
	#left_ray.global_position = global_position
	#right_ray.global_position = global_position
	#if not is_on_floor():
		#velocity.y += 0.98
	#if ground_ray.is_colliding():
		#velocity.y = -velocity.y
	#if left_ray.is_colliding():
		#velocity.x = -velocity.x
	#if right_ray.is_colliding():
		#velocity.x = -velocity.x
	#
	#move_and_slide()
		#


	## Air friction
	#linear_velocity *= 1.0 / (1.0 + air_friction * delta)
#
	## Maximum speed
	#if linear_velocity.length() > max_speed:
		#linear_velocity = linear_velocity.normalized() * max_speed
		

	##if ground_ray.is_colliding():
	##apply_central_impulse(Vector2.UP*50)
#extends RigidBody2D
#class_name Ball
#
#@export var bat_impulse_strength := 1.0
#
#func _ready() -> void:
	#contact_monitor = true
	#max_contacts_reported = 4
#
	##body_entered.connect(_on_body_entered)
#
#func __on_body_entered(body: Node) -> void:
	#if body is CharacterBody2D:
		#var bat := body as CharacterBody2D
#
		#var relative_velocity := bat.velocity - linear_velocity
#
		## Only react to the bat moving toward the ball
		#if relative_velocity.dot(Vector2.UP) > 0.0:
			#apply_central_impulse(
				#bat.velocity * mass * bat_impulse_strength
			#)
			#
#func _on_body_entered(body: Node) -> void:
	#if body is Finger:
		#var bat := body as Finger
#
		## Only give the ball energy if the bat is moving
		#var relative_velocity := bat.velocity - linear_velocity
		## Only react to the bat moving toward the ball
		#if relative_velocity.dot(Vector2.UP) > 0.0:
			#var impulse := bat.velocity * mass * bat_impulse_strength
			#apply_central_impulse(impulse)
			#

	##if ground_ray.is_colliding():
		##apply_central_impulse(Vector2.UP*50)
		##apply_impulse(Vector2(-1000000,-100000))
		##if !is_touched:
			##touch_timer.start()
		##is_touched = true
	##else:
		##is_touched = false
#
#
#
##extends RigidBody2D
##class_name Ball
##@export var ray_cast_2d: RayCast2D
##@export var touch_timer: Timer
##@onready var kick_juice: Node2D = $KickJuice
##
### Called when the node enters the scene tree for the first time.
##func _ready() -> void:
	##pass # Replace with function body.
##
##var is_touched := false
### Called every frame. 'delta' is the elapsed time since the previous frame.
##
##func _integrate_forces(state):
	##if state.linear_velocity.x > 200:
		##state.linear_velocity.x = lerp(state.linear_velocity.x,100.0,0.05)
	##if state.linear_velocity.x < -200:
		##state.linear_velocity.x = lerp(state.linear_velocity.x,-100.0,0.05)
		##
#
##
##func kick(kick_type:String):
	###Engine.time_scale = 0
	###await get_tree().create_timer(0.3, true, false, true).timeout
	###Engine.time_scale = 1.0
	##kick_juice.play(Vector2.UP,2)
	##match kick_type:
##
		##"perfect":
			##pass
		##"good":
			##
			##pass
##
		##"early":
			##pass
##
		##"miss":
			##pass
##
	##
##
##func _on_touch_timer_timeout() -> void:
	##if ray_cast_2d.is_colliding():
			###apply_central_impulse(Vector2.UP*1000000)
			##print("ball 1")
			##StateHandler.emit_ball_touched(self)
	##pass # Replace with function body.
