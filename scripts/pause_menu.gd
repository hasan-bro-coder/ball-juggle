extends CanvasLayer


func enable() -> void:
	layer = 3
	get_tree().paused = true
	show()
	#kick_count.text = "SCORE: " +str(StateHandler.kick_count)
func disable() -> void:
	layer = 0
	get_tree().paused = false
	hide()

func _ready() -> void:
	#StateHandler.ball_touched.connect(enable)
	pass


func _on_pause_pressed() -> void:
	enable()


func _on_Resume_pressed() -> void:
	disable()
	#get_tree().reload_current_scene()
	pass # Replace with function body.
