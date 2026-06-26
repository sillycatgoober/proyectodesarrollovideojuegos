extends Node

var next_scene : String = ""

func play_transition(scene_path : String):
	next_scene = scene_path
	
	# Le pasamos la ruta que pidió el Manager (office.tscn) de forma segura
	get_tree().call_deferred("change_scene_to_file", scene_path)
