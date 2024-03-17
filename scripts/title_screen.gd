extends CanvasLayer

var play := false
var options := false
var exit := false

func _ready():
	$AnimationPlayer.play("fade_in")

func _process(delta):
	if play:
		$Control/TrybPlay.rotation_degrees -= 80 * delta
	if options:
		$Control/TrybOptions.rotation_degrees += 80 * delta
	if exit:
		$Control/TrybExit.rotation_degrees -= 80 * delta


func _on_play_mouse_entered():
	play = true

func _on_play_mouse_exited():
	play = false


func _on_options_mouse_entered():
	options = true

func _on_options_mouse_exited():
	options = false


func _on_exit_mouse_entered():
	exit = true

func _on_exit_mouse_exited():
	exit = false


func _on_play_pressed():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("fade_out")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/test.tscn")

func _on_options_pressed():
	pass
	#if not $AnimationPlayer.is_playing():
		#$AnimationPlayer.play("fade_out")
		#await $AnimationPlayer.animation_finished
		#get_tree().change_scene_to_file("res://scenes/test.tscn")

func _on_exit_pressed():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("fade_out")
		await $AnimationPlayer.animation_finished
		get_tree().quit()
