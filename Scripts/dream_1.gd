extends Node3D

@onready var panel_pausa = $CanvasLayer/PanelOpciones

var pausado: bool = false

func _ready() -> void:
	panel_pausa.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pausa()
		pausado = true

func toggle_pausa() -> void:
	var pausado = not get_tree().paused
	get_tree().paused = pausado
	panel_pausa.visible = pausado
	
	if pausado:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	pass

func _on_salir_button_pressed() -> void:
	if pausado:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_continuar_button_pressed() -> void:
	get_tree().paused = false
	panel_pausa.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pausado = false

func _on_slider_master_value_changed(value: float) -> void:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_slider_fx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))	

func _on_slider_musica_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	


	


	
