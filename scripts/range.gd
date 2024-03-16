extends Line2D

@export var node1 : Node
@export var node2 : Node

func _process(delta):
	if node1:
		points[0] = node1.global_position
	if node2:
		points[1] = node2.global_position
	
	var v = points[0] - points[1]
	if abs(v.x) > 300 or abs(v.y) > 300:
		self.visible = false
		node1.in_range = false
	else:
		self.visible = true
		node1.in_range = true
