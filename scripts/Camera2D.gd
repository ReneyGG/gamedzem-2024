extends Camera2D

@export var follow : Node

func _process(delta):
	if follow:
		global_position = follow.global_position
