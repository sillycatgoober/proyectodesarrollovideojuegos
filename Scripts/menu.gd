extends Control

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/office.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func juego_nuevo():
	GameManager.reset_dreams()
