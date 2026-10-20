extends Node2D
class_name FloatingLabel
@export var float_distance := 40.0
@export var duration := 0.7

@onready var label: Label = $Label


func show_text(text: String, color: Color = Color.WHITE) -> void:
	label.text = text
	label.modulate = color
	label.position.x = -label.size.x / 2.0

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		self, "position:y",
		position.y - float_distance,
		duration
	).from(position.y)

	tween.tween_property(
		label, "modulate:a",
		0.0, duration
	).set_delay(duration * 0.35)

	tween.chain().tween_callback(queue_free)
