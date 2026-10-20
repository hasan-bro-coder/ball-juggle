extends Node2D

@onready var score: Label = $CanvasLayer/Score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StateHandler.kick_count_changed.connect(_on_kick_count_changed)
	pass # Replace with function body.

func _on_kick_count_changed(kick_count:int):
	score.text = str(kick_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass
