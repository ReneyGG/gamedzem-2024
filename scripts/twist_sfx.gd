extends AudioStreamPlayer

@export var gear : Node

func _ready():
	$Timer.start()
	randomize()

func play_twist():
	var i = randi() % 4 + 1
	stream = load("res://sfx/valve"+str(i)+".wav")
	pitch_scale = randf_range(0.8,1.2)
	play()

func _on_timer_timeout():
	if gear.state == "ROTATING":
		play_twist()
