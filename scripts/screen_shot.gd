extends Node
func _input(event):
	if event.is_action_pressed("ui_copy"): # Press Enter/Space to test
		take_screenshot()

func take_screenshot() -> void:
	# Wait for the frame to finish rendering completely
	await RenderingServer.frame_post_draw
	
	# Get the viewport image
	var img = get_viewport().get_texture().get_image()
	
	# Generate a unique timestamp (Format: YYYY-MM-DD_HH.MM.SS)
	var time = Time.get_datetime_dict_from_system()
	var timestamp = "%04d-%02d-%02d_%02d.%02d.%02d" % [
		time.year, time.month, time.day,
		time.hour, time.minute, time.second
	]
	
	# Save as PNG with the unique timestamp
	var path = "C:/Users/hsn/Pictures/shots/screenshot_%s.png" % timestamp
	img.save_png(path)
	print("Screenshot saved to: ", ProjectSettings.globalize_path(path))
