extends Sprite2D
enum { NONE, ROTATING}

var state = NONE
var mouse_on_me: bool = false
var in_range := false
var initial_mouse_pos: Vector2
var initial_angle: float

func _input(event: InputEvent) -> void:
	if not in_range:
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
			rotation = angle + initial_angle

func _on_area_2d_mouse_entered():
	mouse_on_me = true

func _on_area_2d_mouse_exited():
	mouse_on_me = false
