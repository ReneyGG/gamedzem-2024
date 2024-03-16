extends StaticBody2D

@export var gear : Node
@export var min_y : int
@export var max_y : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if gear.state == "ROTATING":
		global_position.y -= gear.speed * 400 * delta
	
	global_position.y += 50 * delta
	
	global_position.y = clamp(global_position.y, max_y, min_y)
