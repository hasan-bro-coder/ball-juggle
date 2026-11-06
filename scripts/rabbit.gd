extends CharacterBody2D
class_name Rabbit

enum CollisionMode {
	KICK,
	ELASTIC
}

@export var max_speed := 3500.0
@export var gravity := 600.0

@export var perfect_hit_angle := 15.0
@export var perfect_hit_multiplier := 2.0

@export var collision_mode := CollisionMode.KICK
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var hit_area: Area2D = $HitArea
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite: Sprite2D = $Sprite2D

var launch_time := 1.0
var launched := false
var launch_power := 0.0

var wall_bounces := 0
const MAX_WALL_BOUNCES := 1


func launch(launch_velocity: Vector2) -> void:
	velocity = launch_velocity
	launch_power = launch_velocity.length() / 1000.0
	launch_time = 1.0
	launched = true


func _physics_process(delta: float) -> void:
	if not launched:
		return

	launch_time += delta / 2.0

	if global_position.y > 400:
		queue_free()
		return

	velocity.y += gravity * delta

	var collision := move_and_collide(velocity * delta)

	if collision:
		var body = collision.get_collider()
		if wall_bounces < MAX_WALL_BOUNCES:
			velocity = velocity.bounce(collision.get_normal()) * 0.9
			wall_bounces += 1
			if wall_bounces == MAX_WALL_BOUNCES:
				collision_shape.disabled = true

	if hit_area.has_overlapping_bodies():
		_on_hit_area_body_entered(hit_area.get_overlapping_bodies()[0])
	sprite.look_at(velocity)
	sprite.rotation_degrees += 90

func _on_hit_area_body_entered(body: Node2D) -> void:
	if not launched:
		return

	if body is Ball:
		var ball: Ball = body

		var launch_dir := velocity.normalized()
		var hit_dir := global_position.direction_to(ball.global_position)

		var angle := rad_to_deg(
			acos(clamp(launch_dir.dot(hit_dir), -1.0, 1.0))
		)

		var power := launch_power * launch_time

		if angle <= perfect_hit_angle and hit_dir.y < 0:
			power *= perfect_hit_multiplier
			Global.show_label(global_position, "PERFECT")
			StateHandler.add_score(200)
		else:
			Global.show_label(global_position, "+1")
			StateHandler.add_score(100)

		ball.launch(500 * power, hit_dir, global_position)

		StateHandler.add_kick(1)
		StateHandler.emit_ball_hit(position, ball)
		queue_free()


#extends CharacterBody2D
#class_name Rabbit
#
#@export var max_speed := 3500.0
#@export var gravity := 600.0
##@export var ball_impulse_scale := 1.0
#
#@onready var hit_area: Area2D = $HitArea
#
#@export var perfect_hit_angle := 15.0 # Degrees
#@export var perfect_hit_multiplier := 2.0
#
#@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
#
#var lauch_time := 1.0
#var launched := false
#var launch_power := 0.0
#
#
#func _ready() -> void:
	#print(hit_area.has_overlapping_bodies(),hit_area.get_overlapping_bodies())
	#
#
#
#func launch(launch_velocity: Vector2) -> void:
	#velocity = launch_velocity
	#launch_power = launch_velocity.length() / (10 * 100)
	#launched = true
#
#
#func _physics_process(delta: float) -> void:
	#if not launched:
		#return
	#lauch_time+=delta/2
	#if global_position.y > 400: 
		#queue_free()
	#velocity.y += gravity * delta
	#move_and_slide()
	#if hit_area.has_overlapping_bodies():
		#_on_hit_area_body_entered(hit_area.get_overlapping_bodies()[0])
#
#
#
#
#func _on_hit_area_body_entered(body: Node2D) -> void:
	#if not launched:
		#return
#
	#if body is Ball:
		#var ball: Ball = body as Ball
#
		## Rabbit's actual launch direction
		#var launch_dir := velocity.normalized()
#
		## Direction from rabbit center to ball center
		#var hit_dir := global_position.direction_to(ball.global_position)
	#
		## Angle between launch direction and center-to-center direction
		#var angle := rad_to_deg(
			#acos(clamp(launch_dir.dot(hit_dir), -1.0, 1.0))
		#)
		##print(hit_dir,angle)
		#var power := launch_power * lauch_time 
		##+ (StateHandler.kick_count * 0.1)
		#print(power," ",launch_power," ",lauch_time)
		## Perfect hit if directions align closely
		#if angle <= perfect_hit_angle and hit_dir.y < 0:
			#power *= perfect_hit_multiplier
			#Global.show_label(global_position,"PERFECT")
			#ball.launch(500 * power, hit_dir ,global_position)
			##ball.launch(500 * power, Vector2(0,-1),global_position)
			#StateHandler.add_score(200)
			#print("perferct hit")
		#else:
			#var theta := deg_to_rad(randi_range(135,45))
			#Global.show_label(global_position,"+1" )
			#var rand_dir = Vector2(cos(theta),-sin(theta))
			#print(launch_dir,hit_dir)
			#ball.launch(500 * power, hit_dir ,global_position)
			#StateHandler.add_score(100)
		#StateHandler.add_kick(1)
		#StateHandler.emit_ball_hit(position, ball)
		#queue_free()
