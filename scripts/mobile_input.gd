extends Control

signal kick(direction: Vector2, charge: float)

@export var minimum_swipe_distance := 50.0
@export var maximum_charge_time := 1.5

var active_touches = {}
var disabled := true

func enable():
	show()
	disabled = false
func disable():
	hide()
	disabled = true
	
func _input(event):
	if disabled:
		return
	if event is InputEventKey:
		var e: InputEventKey = event
		#print(e,e.as_text_keycode(),e.as_text_key_label(),OS.get_keycode_string(e.keycode))
		if OS.get_keycode_string(e.keycode) == "Up":
			kick.emit(Vector2.UP,0.1)
	if event is InputEventScreenTouch:

		if event.pressed:

			active_touches[event.index] = {
				"start_position": event.position,
				"start_time": Time.get_ticks_msec() / 1000.0
			}
		
		else:
			if active_touches.has(event.index):
				
				process_touch(event)

				active_touches.erase(event.index)


func process_touch(event):

	var data = active_touches[event.index]

	var start_position: Vector2 = data["start_position"]
	var start_time: float = data["start_time"]

	var swipe_vector = event.position - start_position

	var distance = swipe_vector.length()


	# Ignore taps
	if distance < minimum_swipe_distance:
		return


	var direction = swipe_vector.normalized()


	# Only upward kicks
	if direction.y > -0.3:
		return


	# Calculate charge
	var current_time = Time.get_ticks_msec() / 1000.0

	var hold_time = current_time - start_time

	var charge = clamp(
		hold_time / maximum_charge_time,
		0.0,
		1.0
	)


	direction = snap_direction(direction)

	#if direction != -1:
	kick.emit(direction, charge)


func snap_direction(direction: Vector2) -> Vector2:

	#if direction.x < -0.35:
		#return Vector2(-0.7, -0.7)
#
	#elif direction.x > 0.35:
		#return Vector2(0.7, -0.7)

	print(direction.x)
	return Vector2(direction.x, -1)
	return Vector2(0, -1)
