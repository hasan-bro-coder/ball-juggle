extends Node2D

@onready var score: Label = $CanvasLayer/Score

@onready var ball: Ball = $Ball
@onready var camera: Camera2D = $Camera2D
@onready var parallax_2d: Parallax2D = $Parallax2D
@onready var original := parallax_2d.modulate
var hue := 0.33 # Green
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StateHandler.kick_count_changed.connect(_on_kick_count_changed)
	pass # Replace with function body.

func _on_kick_count_changed(kick_count:int):
	score.text = str(kick_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hue = fmod(hue + 0.01 * delta, 1.0)
	parallax_2d.modulate = Color.from_hsv(
		hue, original.s, original.v, original.a
	)
	if ball.velocity.y < 50 and ball.global_position.y < -300:
		camera.global_position.y = ball.global_position.y
	else:
		camera.global_position.y = 160
	pass
