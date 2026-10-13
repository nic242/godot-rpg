extends Node

var player_current_attack = false

var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_posx = 217
var player_exit_cliffside_posy = 18
var player_start_posx = 217
var player_start_posy = 135 

var game_first_loadin = true

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else :
			current_scene = "world"

func reset_run():
	game_first_loadin = true
	current_scene = "world"
	transition_scene = false
	player_current_attack = false
	Engine.time_scale = 1.0
			
			
func show_popup (text : String, pos: Vector2, color : Color):
	var label = Label.new()
	label.text = text
	label.global_position = pos
	label.modulate  = color
	label.z_index = 100
	label.add_theme_font_size_override("font_size", 10)
	get_tree().current_scene.add_child(label)
	
	var tween = label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "global_position:y", pos.y - 20, 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(label.queue_free)
	
