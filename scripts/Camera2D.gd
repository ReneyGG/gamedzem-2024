extends Camera2D

@export var alive_path : NodePath
@export var ghost_path : NodePath

var alive
var ghost

func _ready():
	alive = get_node(alive_path)
	ghost = get_node(ghost_path)

func _process(delta):
	var pos1 = alive.global_position
	var pos2 = ghost.global_position
	global_position.x = (pos1.x+pos2.x)/2
	global_position.y = (pos1.y+pos2.y)/2
