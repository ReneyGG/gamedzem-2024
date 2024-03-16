extends CharacterBody2D

@onready var sprite := $Sprite2D

@export var max_speed := 440
@export var gravity := 50.0
@export var jump_force := 1200
@export var acceleration := 220
@export var jump_buffer_time := 5
@export var cayote_time := 5
@export var camera_path : NodePath

var camera
var landed := false
var ui_on := false
var jump_counter := 0
var jump_buffer_counter := 0
var cayote_counter := 0
var max_fall_speed := 2000
var state_machine
var current
var ghost_mode := false
var ghost_node = null

func _ready():
	camera = get_node(camera_path)
	camera.follow = self
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
		if jump_counter < 0:
			jump_counter += 1
			cayote_counter = 1
	
	velocity.y += gravity
	
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	if Input.is_action_pressed("alive_right") and not ghost_mode:
		velocity.x += acceleration
		sprite.flip_h = false
		if is_on_floor():
			pass
			#state_machine.travel("run")
		
	elif Input.is_action_pressed("alive_left") and not ghost_mode:
		velocity.x -= acceleration
		sprite.flip_h = true
		if is_on_floor():
			pass
			#state_machine.travel("run")
	
	else:
		#$Run.playing = false
		#$DustTrailRun.emitting = false
		if is_on_floor():
			pass
			#state_machine.travel("idle")
		velocity.x = lerp(velocity.x,0.0,0.3)
	
	if Input.is_action_just_pressed("mecha"):
		if ghost_mode:
			get_parent().delete_ghost()
		else:
			get_parent().spawn_ghost()
	
	if Input.is_action_just_pressed("alive_up") and not ghost_mode:
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0:
		#if is_on_floor() or is_on_wall():
			#$DustTrail.restart()
			#$Jump.pitch_scale = rand_range(0.8,1.2)
			#$Jump.play()
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
		sprite.scale = Vector2(0.7, 1.3)
		#state_machine.travel("jump")
	
	if Input.is_action_just_released("alive_up") and not ghost_mode:
		if velocity.y < 0:
			velocity.y += 600
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	sprite.scale.x = lerp(sprite.scale.x, 1.0, 0.2)
	sprite.scale.y = lerp(sprite.scale.y, 1.0, 0.2)
	move_and_slide()
	var view = get_viewport_rect().size/2

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
