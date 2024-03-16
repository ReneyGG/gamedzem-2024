extends CharacterBody2D

@export var offset = Vector2(0, -800)
@export var duration = 20.0

func _ready():
	start_tween()

func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($SpiderBody, "position", offset, duration * 10)
	
