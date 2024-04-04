extends CanvasLayer

var menu := false

func _ready():
	$Yay.play()
	$Ambn.play()
	$Death.play()
	$AnimationPlayer.play("fade_in")

func _process(delta):
	if menu:
		$Control/TrybMenu.rotation_degrees -= 80 * delta

func _on_menu_button_pressed():
	if not $AnimationPlayer.is_playing():
		$Click.play()
		await $Click.finished
		get_tree().paused = false
		$AnimationPlayer.play("fade_out")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_menu_button_mouse_entered():
	menu = true
	$Corg.playing = true
	$Hover.play()

func _on_menu_button_mouse_exited():
	menu = false
	$Corg.playing = false
