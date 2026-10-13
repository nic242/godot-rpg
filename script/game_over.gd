extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	$Dim/VBox/RestartButton.pressed.connect(_on_restart)
	$Dim/VBox/RestartButton.grab_focus()

func _on_restart():
	get_tree().paused = false
	global.reset_run()
	get_tree().change_scene_to_file("res://scene/world.tscn")
