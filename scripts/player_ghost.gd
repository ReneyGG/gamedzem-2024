extends CharacterBody2D

@onready var sprite := $Sprite2D

@export var max_speed := 440
@export var gravity := 50.0
@export var jump_force := 1200
@export var acceleration := 220
@export var jump_buffer_time := 5
@export var cayote_time := 5

var landed := false
var camera
var ui_on := false
var jump_counter := 0
var jump_buffer_counter := 0
var cayote_counter := 0
var max_fall_speed := 2000
var state_machine
var current

func _ready():
	pass
	#$Sprite2D.play("fly")
	#camera = get_parent().get_node("Camera2D")
	#camera = get_parent().find_node("Camera2D")
	#state_machine = $AnimationTree["parameters/playback"]
	#state_machine.start("idle")

func _physics_process(_delta):
	#current = state_machine.get_current_node()
	
	if current == "death":
		return
	
	if ui_on:
		return
	
	if $Sprite2D.animation == "haunt":
		return
	
	#if is_on_floor() and current == "run":
		#$DustTrailRun.emitting = true
	#else:
		#$DustTrailRun.emitting = false
	
	if is_on_floor():
		if landed:
			landed = false
			#$DustTrail.restart()
			#$Land.pitch_scale = rand_range(0.8,1.2)
			#$Land.play()
		cayote_counter = cayote_time
		jump_counter = 0

	if not is_on_floor():
		landed = true
		#state_machine.travel("fall")
		if cayote_counter > 0:
			cayote_counter -= 1
	
	if jump_buffer_counter > 0:
		if jump_counter < 1:
			jump_counter += 1
			cayote_counter = 1
	
	if Input.is_action_pressed("alive_right"):
		velocity.x += acceleration
		sprite.flip_h = true
	if Input.is_action_pressed("alive_left"):
		velocity.x -= acceleration
		sprite.flip_h = false
	if Input.is_action_pressed("alive_up"):
		velocity.y -= acceleration
	if Input.is_action_pressed("alive_down"):
		velocity.y += acceleration
	
	velocity.x = lerp(velocity.x,0.0,0.1)
	velocity.y = lerp(velocity.y,0.0,0.1)
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	sprite.scale.x = lerp(sprite.scale.x, 1.0, 0.2)
	sprite.scale.y = lerp(sprite.scale.y, 1.0, 0.2)
	move_and_slide()
	#var view = get_viewport_rect().size/2
	#global_position.x = clamp(global_position.x, camera.global_position.x-view.x, camera.global_position.x+view.x)
	#global_position.y = clamp(global_position.y, camera.global_position.x+view.y, camera.global_position.x-view.y)

func death():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Hub.tscn")

func play_step():
	pass
	#$Step.pitch_scale = rand_range(0.8,1.2)
	#$Step.play()

func stop_movement(b):
	if b:
		#$Run.playing = false
		$DustTrailRun.emitting = false
		#state_machine.travel("idle")
		ui_on = true
	else:
		ui_on = false

func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	$Freeze.start(duration * timeScale)

func _on_Freeze_timeout():
	Engine.time_scale = 1.0

func _on_timer_timeout():
	$Sprite2D.play("fly")
