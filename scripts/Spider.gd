extends CharacterBody2D

@export var offset = Vector2(0, -800)
@export var duration = 7.5
@export var rotation_speed = 1.5

func _ready():
	start_tween()
	start_tween2()

#Poruszanie Kolizji
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property($Area2D/CollisionShape2D, "position", Vector2(0,0), duration * 5)

#Poruszanie Ciała(Sprite)
func start_tween2():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property($SpiderBody, "position", Vector2(0,0), duration * 5)

#DeathZone
func _on_area_2d_body_entered(body):
	print("Okay masta, letz kill da hoe, beeeeetch(jojo reference here)")

