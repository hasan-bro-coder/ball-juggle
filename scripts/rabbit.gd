extends CharacterBody2D
class_name Rabbit

@export var max_speed := 3500.0
@export var gravity := 600.0
#@export var ball_impulse_scale := 1.0

@onready var hit_area: Area2D = $HitArea

@export var perfect_hit_angle := 15.0 # Degrees
@export var perfect_hit_multiplier := 2.0



var launched := false
var launch_power := 0.0


func _ready() -> void:
	hit_area.body_entered.connect(_on_hit_area_body_entered)


func launch(launch_velocity: Vector2) -> void:
	velocity = launch_velocity
	launch_power = launch_velocity.length() / (10 * 100)
	launched = true


func _physics_process(delta: float) -> void:
	if not launched:
		return
	if global_position.y < -400: 
		queue_free()
	velocity.y += gravity * delta
	move_and_slide()




func _on_hit_area_body_entered(body: Node2D) -> void:
	if not launched:
		return

	if body is Ball:
		var ball: Ball = body as Ball

		# Rabbit's actual launch direction
		var launch_dir := velocity.normalized()

		# Direction from rabbit center to ball center
		var hit_dir := global_position.direction_to(ball.global_position)
	
		# Angle between launch direction and center-to-center direction
		var angle := rad_to_deg(
			acos(clamp(launch_dir.dot(hit_dir), -1.0, 1.0))
		)
		#print(hit_dir,angle)
		var power := launch_power

		# Perfect hit if directions align closely
		if angle <= perfect_hit_angle and hit_dir.y < 0:
			power *= perfect_hit_multiplier
			Global.show_label(global_position,"PERFECT")
			ball.launch(500 * power, Vector2(0,-1),global_position)
			StateHandler.add_score(200)
			print("perferct hit")
		else:
			var theta := deg_to_rad(randi_range(135,45))
			Global.show_label(global_position,"+100" )
			var rand_dir = Vector2(cos(theta),-sin(theta))
			print(launch_dir,hit_dir)
			ball.launch(500 * power, hit_dir ,global_position)
			StateHandler.add_score(100)
		StateHandler.add_kick(1)
		StateHandler.emit_ball_hit(position, ball)
		queue_free()
