extends Node2D

@export var offset = Vector2(0, -800)
@export var duration = 20
@export var mov_speed = 5

var movinghead = 100

func _ready():
	pass

func _physics_process(delta):
	global_position.y -= 50 * delta

##Poruszanie Kolizji
#func start_tween():
	#var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#tween.tween_property($Area2D, "position", offset, duration * mov_speed)
#
##Poruszanie Ciała(Sprite)
#func start_tween2():
	#var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#tween.tween_property($SpiderBody, "position", offset, duration * mov_speed)

#DeathZone
func _on_area_2d_body_entered(body):
	print("Okay masta, letz kill da hoe, beeeeetch(jojo reference here)")
