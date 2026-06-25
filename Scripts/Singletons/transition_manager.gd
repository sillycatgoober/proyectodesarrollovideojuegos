extends Node

var next_scene : String = ""

func play_transition(scene_path : String):
	next_scene = scene_path
	get_tree().change_scene_to_file("res://Scenes/UI/animacion_transicion.tscn")
