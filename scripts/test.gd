extends Node2D

@onready var lines = get_node("Lines")
@onready var player_alive = get_node("PlayerAlive")

var range = preload("res://scenes/range.tscn")
var ghost = preload("res://scenes/player_ghost.tscn")
var proc := false

func _ready():
	MenuAmbience.stop()
	$Pause.hide()
	$Sfx/Ambient.play()
	player_alive = get_node("PlayerAlive")

func _physics_process(delta):
	get_node("Camera2D/CanvasLayer/Control/ProgressBar").value = player_alive.progress
	#$Foreground.position.x += (player_alive.global_position.x*delta*2)-$Foreground.position.x
	if Input.is_action_just_pressed("mecha") and player_alive.in_range:
		get_ghost()

func get_ghost():
	if proc:
		return
	if player_alive.ghost_mode:
		delete_ghost()
	else:
		spawn_ghost()

func delete_ghost():
	proc = true
	#get_node("Camera2D/Rotating").hide()
	for i in lines.get_children():
		i.queue_free()
	
	player_alive.ghost_mode = false
	player_alive.ghost_node = null
	get_node("Camera2D").follow = player_alive
	$Sfx/Opetanie.play()
	get_node("PlayerGhost/Sprite2D").play("haunt")
	await get_node("PlayerGhost/Sprite2D").animation_finished
	get_node("PlayerGhost").queue_free()
	proc = false

func spawn_ghost():
	proc = true
	$Sfx/OdOpetanie.play()
	#get_node("Camera2D/Rotating").show()
	player_alive.ghost_mode = true
	var ghost_node = ghost.instantiate()
	ghost_node.global_position = player_alive.global_position
	player_alive.ghost_node = ghost_node
	add_child(ghost_node)
	get_node("Camera2D").follow = ghost_node
	get_node("PlayerGhost/Sprite2D").play("unhaunt")
	await get_node("PlayerGhost/Sprite2D").animation_finished
	proc = false
	
	for i in get_children():
		if i.is_in_group("interact"):
			var range_node = range.instantiate()
			get_node("Lines").add_child(range_node)
			range_node.node1 = i
			range_node.node2 = get_node("PlayerGhost")

func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/winscreen.tscn")

func _on_death_body_entered(body):
	$squeek.play()
	await $squeek.finished
	get_tree().change_scene_to_file("res://scenes/deathscreen.tscn")
