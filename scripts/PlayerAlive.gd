extends CharacterBody2D

@onready var sprite := $Sprite2D

@export var max_speed := 440
@export var gravity := 50.0
@export var jump_force := 1200
@export var acceleration := 220
@export var jump_buffer_time := 5
@export var cayote_time := 5
@export var camera_path : NodePath

#var in_range := true
var camera
var landed := false
var ui_on := false
var jump_counter := 0
var jump_buffer_counter := 0
var cayote_counter := 0
var max_fall_speed := 2000
var state_machine
var animation
var current
var ghost_mode := false
var ghost_node = null
var progress := 60.0


enum { NONE, ROTATING}

var state = NONE
var mouse_on_me: bool = false
var in_range := true
var initial_mouse_pos: Vector2
var initial_angle: float

func _input(event: InputEvent) -> void:
	if not in_range or not ghost_mode:
		return
	
	if event is InputEventMouseButton:
		if event.pressed: # press button
			if mouse_on_me:
				initial_angle = rotation
				initial_mouse_pos = get_local_mouse_position().rotated(rotation)
				state = ROTATING
		else: # release button
			state = NONE
	
	if event is InputEventMouseMotion:
		if state == ROTATING:
			var current_mouse_pos: Vector2 = get_local_mouse_position().rotated(rotation)
			var angle = initial_mouse_pos.angle_to(current_mouse_pos)
			$Sprite2D.rotation = angle + initial_angle
			if progress < 100.0:
				var add
				var mouse_v = event.velocity
				if abs(mouse_v.x) > abs(mouse_v.y):
					add = abs(mouse_v.x)
				else:
					add = abs(mouse_v.y)
				progress += 0.0001*add + 0.0785

func _on_area_2d_mouse_entered():
	mouse_on_me = true

func _on_area_2d_mouse_exited():
	mouse_on_me = false

func _ready():
	randomize()
	$Timer.start()
	camera = get_node(camera_path)
	camera.follow = self
	#camera = get_parent().get_node("Camera2D")
	#camera = get_parent().find_node("Camera2D")
	animation = get_node("AnimationPlayer")
	state_machine = $AnimationTree["parameters/playback"]
	state_machine.start("idle")

func _physics_process(_delta):
	current = state_machine.get_current_node()
	#current = animation.current_animation
	
	if current == "death":
		return
	
	if ui_on:
		return
	
	if progress > 0.0:
		progress -= 0.08
	
	if is_on_floor() and current == "run":
		$DustTrailRun.emitting = true
	else:
		$DustTrailRun.emitting = false
	
	if is_on_floor():
		if landed:
			landed = false
			$DustTrail.restart()
			$Land.pitch_scale = randf_range(0.8,1.2)
			#$Land.play()
		cayote_counter = cayote_time
		jump_counter = 0

	if not is_on_floor():
		landed = true
		state_machine.travel("fall")
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
		sprite.flip_h = true
		if is_on_floor():
			state_machine.travel("run")
		
	elif Input.is_action_pressed("alive_left") and not ghost_mode:
		velocity.x -= acceleration
		sprite.flip_h = false
		if is_on_floor():
			state_machine.travel("run")
	
	else:
		#$Run.playing = false
		$DustTrailRun.emitting = false
		if is_on_floor():
			state_machine.travel("idle")
		velocity.x = lerp(velocity.x,0.0,0.3)
	
	#if Input.is_action_just_pressed("mecha") and in_range:
		#get_ghost()
	
	if Input.is_action_just_pressed("alive_up") and not ghost_mode and progress > 0.0:
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0:
		if is_on_floor():
			$DustTrail.restart()
			$Jump.pitch_scale = randf_range(0.8,1.2)
			$Jump.play()
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
		sprite.scale = Vector2(0.7, 1.3)
		state_machine.travel("jump")
	
	if Input.is_action_just_released("alive_up") and not ghost_mode:
		if velocity.y < 0:
			velocity.y += 600
	
	velocity.x = clamp(velocity.x, -max_speed * (progress/100), max_speed * (progress/100))
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
		$DustTrailRun.emitting = false
		state_machine.travel("idle")
		ui_on = true
	else:
		ui_on = false

func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	$Freeze.start(duration * timeScale)

func _on_Freeze_timeout():
	Engine.time_scale = 1.0

func _on_timer_timeout():
	if state == ROTATING:
		$Wind.pitch_scale = randf_range(0.7,1.4)
		$Wind.play()
