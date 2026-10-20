extends Node2D

@export var sprite: AnimatedSprite2D

@onready var ball: Sprite2D = $CanvasLayer/Control/Ball



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#sprite.play("idle")
	#ball.position.x = get_window().size.x/2
	#ball.position.y = get_window().size.y/2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_previous_pressed() -> void:
	sprite.play("idle")
	pass # Replace with function body.


func _on_next_pressed() -> void:
	sprite.play("idle")
	pass # Replace with function body.
