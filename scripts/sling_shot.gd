extends Node2D
class_name Slingshot

@export var rabbit_scene: PackedScene = preload("res://scenes/rabbit.tscn")
@export_range(1,15,1) var power_scale := 15.0
@export_range(1,4,0.1) var pull_falloff := 2.0
@export var max_pull := 100
@onready var finger: Sprite2D = $Sprite2D

var anchor := Vector2.ZERO
var aiming := false
var rabbit : Rabbit
@onready var hit_audio: AudioStreamPlayer = $hit
@onready var path_preview: PathPreview = $PathPreview

func _ready() -> void:
	StateHandler.hit.connect(ball_hit)
func _input(event: InputEvent) -> void:
	if event is InputEventKey and (event.keycode == KEY_X or event.keycode == KEY_SPACE):
		if event.pressed and not event.echo:
			start_aim(get_global_mouse_position())
		elif not event.pressed:
			release_shot()

	elif event is InputEventMouseMotion and Input.is_key_pressed(KEY_X) and aiming:
		update_aim(get_global_mouse_position())

	elif event is InputEventScreenTouch:
		if event.pressed:
			start_aim(event.position)
		else:
			release_shot()

	elif event is InputEventScreenDrag and aiming:
		update_aim(event.position)


func start_aim(pos: Vector2) -> void:
	if aiming:
		return

	anchor = pos
	aiming = true
	path_preview.hide_path()
	rabbit = rabbit_scene.instantiate()
	add_child(rabbit)

	rabbit.global_position = anchor
	finger.global_position = anchor
	#finger.show()

func update_aim(pos: Vector2) -> void:
	if not rabbit:
		return

	var pull := (pos - anchor) / pull_falloff

	if pull.length() > max_pull:
		pull = pull.normalized() * max_pull

	rabbit.global_position = anchor + pull
	var dir := (anchor - rabbit.global_position)
	rabbit.rotation = -atan2(dir.x,dir.y)
	var launch_velocity := dir * power_scale

	path_preview.update_path(
		rabbit.global_position,
		launch_velocity,
		rabbit.gravity
	)


func release_shot() -> void:
	if not aiming:
		return

	aiming = false
	path_preview.hide_path()

	var pull := anchor - rabbit.global_position
	var launch_velocity := pull * power_scale

	rabbit.launch(launch_velocity)
	rabbit = null
	finger.hide()
#
#func release_shot() -> void:
	#if not aiming:
		#return
#
	#aiming = false
#
	#var pull := anchor - rabbit.global_position
	#var launch_velocity := pull * power_scale
#
	#rabbit.launch(launch_velocity)
	#rabbit = null
	#finger.hide()

func ball_hit(_position:Vector2,ball:Ball):
	hit_audio.play()
	get_tree().paused = true
	await get_tree().create_timer(0.4).timeout
	get_tree().paused = false
	ball.create_ring(2)
