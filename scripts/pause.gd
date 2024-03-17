extends CanvasLayer

var play := false
var options := false
var exit := false

func _ready():
	pass

func _process(delta):
	if play:
		$Control/TrybBack.rotation_degrees -= 80 * delta
	if options:
		$Control/TrybOptions.rotation_degrees += 80 * delta
	if exit:
		$Control/TrybExit.rotation_degrees -= 80 * delta
	
	if Input.is_action_just_pressed("escape"):
		if get_node_or_null("Options"):
			return
		if get_tree().paused:
			get_tree().paused = false
			hide()
		else:
			get_tree().paused = true
			show()

func _on_options_mouse_entered():
	options = true

func _on_options_mouse_exited():
	options = false


func _on_exit_mouse_entered():
	exit = true

func _on_exit_mouse_exited():
	exit = false

func _on_options_pressed():
	if not $AnimationPlayer.is_playing():
		var nod = load("res://scenes/options.tscn").instantiate()
		add_child(nod)

func _on_exit_pressed():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("fade_out")
		await $AnimationPlayer.animation_finished
		get_tree().quit()

func _on_back_pressed():
	get_tree().paused = false
	hide()

func _on_back_mouse_entered():
	play = true

func _on_back_mouse_exited():
	play = false
