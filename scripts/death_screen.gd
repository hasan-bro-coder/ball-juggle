extends CanvasLayer

@export var kick_count: Label
@export var disabled := true

func enable(_ball) -> void:
	show()
	kick_count.text = "SCORE: " +str(StateHandler.kick_count)
	layer = 10
func disable() -> void:
	hide()

func _ready() -> void:
	if not disabled:
		StateHandler.ball_touched.connect(enable)


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
