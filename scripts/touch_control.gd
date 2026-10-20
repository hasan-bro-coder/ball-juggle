extends Control
class_name TouchControl

@export_category("Input")
@export var input: StringName
@export var texture: Texture2D
@export var button: Button

func _ready() -> void:
	button.text = ""
	button.icon = texture

func _on_button_button_down() -> void:
	if not input.is_empty():
		Input.action_press(input)

func _on_button_button_up() -> void:
	if not input.is_empty():
		Input.action_release(input)

# Clean up input if the node is removed or hidden while held down
func _exit_tree() -> void:
	if not input.is_empty() and Input.is_action_pressed(input):
		Input.action_release(input)
