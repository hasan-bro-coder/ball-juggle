extends Node2D

const MAIN = preload("uid://dbbrvjhubor7u")


func _ready() -> void:
	if Global._debug:
		await get_tree().physics_frame
		get_tree().change_scene_to_packed(MAIN)
	pass 


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)
	pass # Replace with function body.
