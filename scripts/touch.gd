extends CharacterBody2D
class_name Finger
var target_position: Vector2
var touching := false

func _ready() -> void:
	target_position = global_position


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touching = true
			target_position = event.position
			show()
		else:
			touching = false
			hide()

	elif event is InputEventScreenDrag:
		
		target_position = event.position
	elif event is InputEventMouseMotion:
		target_position = event.position
	


func _physics_process(delta: float) -> void:
	touching = true
	if not touching:
		velocity = Vector2.ZERO
		return

	# Velocity of the finger/bat
	#if Engine.get_frames_drawn() % 20:
		#print(clamp((target_position - global_position),(target_position - global_position).normalized(),(target_position - global_position).normalized() * 5))
	velocity =  clamp((target_position - global_position),(target_position - global_position).normalized(),(target_position - global_position).normalized() * 5) / delta

	# Move the CharacterBody2D
	move_and_collide(velocity * delta)
