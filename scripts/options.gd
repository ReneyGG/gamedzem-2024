extends CanvasLayer

var menu := false
var accept := false

func _ready():
	pass

func _process(delta):
	if menu:
		$Control/TrybMenu.rotation_degrees -= 80 * delta
	if accept:
		$Control/TrybAccept.rotation_degrees += 80 * delta

func _on_menu_button_pressed():
	if not $AnimationPlayer.is_playing():
		get_tree().paused = false
		$AnimationPlayer.play("fade_out")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_menu_button_mouse_entered():
	menu = true

func _on_menu_button_mouse_exited():
	menu = false


func _on_accept_button_pressed():
	queue_free()

func _on_accept_button_mouse_entered():
	accept = true

func _on_accept_button_mouse_exited():
	accept = false

func _on_fullscreen_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
