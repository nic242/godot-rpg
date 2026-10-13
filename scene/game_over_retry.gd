extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	global.reset_run()
	get_tree().change_scene_to_file("res://scene/world.tscn")
