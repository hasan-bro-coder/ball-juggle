extends Control

@export var ball: Node2D
@export var margin := 30.0

@export var min_ball_scale := 0.3
@export var max_vertical_distance := 500.0

@onready var ball_icon: Control = $BallTexture
@onready var pin_texture: TextureRect = $PinTexture


func _process(_delta):
	update_indicator()

func update_indicator():
	var screen_size = get_viewport_rect().size
	
	# Ball position in screen coordinates
	var ball_screen_pos = ball.get_global_transform_with_canvas().origin
	#ball_screen_pos.y -= 28.0
	
	# Check if ball is visible
	var screen_rect = Rect2(Vector2.ZERO, screen_size)
	
	if screen_rect.has_point(ball_screen_pos):
		hide()
		return
	
	show()
	
	
	# Clamp the position to the screen border
	var indicator_pos = ball_screen_pos.clamp(
		Vector2(margin, margin),
		screen_size - Vector2(margin, margin) 
		#- Vector2(64,64)
	)
	
	position = indicator_pos
	
	
	# Handle rotation only for corners
	update_rotation(ball_screen_pos, screen_size)
	
	
	# Scale ball based ONLY on vertical distance
	update_ball_scale(ball_screen_pos, screen_size)
	
func update_rotation(ball_pos: Vector2, screen_size: Vector2):
	var outside_x = ball_pos.x < 0 or ball_pos.x > screen_size.x
	var outside_y = ball_pos.y < 0 or ball_pos.y > screen_size.y
	
	# Default: no rotation
	rotation = 0.0

		
	# Only rotate when both axes are outside
	if outside_x and outside_y:
		
		if ball_pos.x < 0 and ball_pos.y < 0:
			# Top-left
			rotation = deg_to_rad(45)
		
		elif ball_pos.x > screen_size.x and ball_pos.y < 0:
			# Top-right
			rotation = deg_to_rad(-45)
		
		elif ball_pos.x < 0 and ball_pos.y > screen_size.y:
			# Bottom-left
			rotation = deg_to_rad(-135)
		
		elif ball_pos.x > screen_size.x and ball_pos.y > screen_size.y:
			# Bottom-right
			rotation = deg_to_rad(135)
	elif outside_x:
		if ball_pos.x < 0:
			rotation = deg_to_rad(-90)
		if ball_pos.x > screen_size.x:
			rotation = deg_to_rad(90)
	elif outside_y:
		rotation = deg_to_rad(180)

func update_ball_scale(ball_pos: Vector2, screen_size: Vector2):
	var vertical_distance = 0.0
	
	# Only care about ball being ABOVE the screen
	if ball_pos.y < 0:
		vertical_distance = abs(ball_pos.y)
	
	# Convert distance to 0 → 1
	var t = clamp(
		vertical_distance / max_vertical_distance,
		0.0,
		1.0
	)
	
	# Close = 1.0 scale
	# Far up = min_ball_scale
	var scale_amount = lerp(1.0, min_ball_scale, t)
	#print(scale_amount," ",vertical_distance)
	ball_icon.scale = Vector2.ONE * scale_amount

func get_border_position(
	center: Vector2,
	direction: Vector2,
	rect: Rect2
) -> Vector2:
	
	var tx = INF
	var ty = INF
	
	if direction.x > 0:
		tx = (rect.end.x - center.x) / direction.x
	elif direction.x < 0:
		tx = (rect.position.x - center.x) / direction.x
	
	if direction.y > 0:
		ty = (rect.end.y - center.y) / direction.y
	elif direction.y < 0:
		ty = (rect.position.y - center.y) / direction.y
	
	var t = min(tx, ty)
	
	return center + direction * t
