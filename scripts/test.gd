extends Node2D

@onready var lines = get_node("Lines")
@onready var player_alive = get_node("PlayerAlive")

var range = preload("res://scenes/range.tscn")
var ghost = preload("res://scenes/player_ghost.tscn")

func _ready():
	pass

func _process(delta):
	pass

func delete_ghost():
	for i in lines.get_children():
		i.queue_free()
	
	player_alive.ghost_mode = false
	player_alive.ghost_node = null
	get_node("Camera2D").follow = player_alive
	get_node("PlayerGhost").queue_free()

func spawn_ghost():
	player_alive.ghost_mode = true
	var ghost_node = ghost.instantiate()
	ghost_node.global_position = player_alive.global_position
	add_child(ghost_node)
	get_node("Camera2D").follow = ghost_node
	
	for i in range(1):
		var range_node = range.instantiate()
		get_node("Lines").add_child(range_node)
		range_node.node1 = get_node("PlayerAlive")
		range_node.node2 = get_node("PlayerGhost")
