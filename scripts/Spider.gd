extends CharacterBody2D

@export var offset = Vector2(0, -800)
@export var duration = 20.0

func _ready():
	start_tween()
	start_tween2()

func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property($Area2D/CollisionShape2D, "position", Vector2(0,0), duration * 5)

func start_tween2():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property($SpiderBody, "position", Vector2(0,0), duration * 5)

func _on_area_2d_body_entered(body):
	print("Okay masta, letz kill da hoe, beeeeetch") # Replace with function body.
