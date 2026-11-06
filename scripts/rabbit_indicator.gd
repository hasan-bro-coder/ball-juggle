extends Control

@export var ball: Node2D
@export var margin := 10.0
@onready var pin_texture: TextureRect = $PinTexture


func _process(_delta):
	update_indicator()

func update_indicator():
	var screen_size = get_viewport_rect().size
	var ball_screen_pos = ball.get_global_transform_with_canvas().origin
	var screen_rect = Rect2(Vector2.ZERO, screen_size)
	if screen_rect.has_point(ball_screen_pos) or (ball_screen_pos.y > screen_size.y) or ball_screen_pos.x > screen_size.x or ball_screen_pos.x < 0:
		hide()
		return
	show()
	var indicator_pos = ball_screen_pos.clamp(
		Vector2(margin, margin),
		screen_size - Vector2(margin, margin) 
		#- Vector2(64,64)
	)
	
	position = indicator_pos
	
	update_rotation(ball_screen_pos, screen_size)
	

	
func update_rotation(ball_pos: Vector2, screen_size: Vector2):
	var outside_y = ball_pos.y < 0
	rotation = 0.0
	if outside_y:
		rotation = deg_to_rad(180)


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
