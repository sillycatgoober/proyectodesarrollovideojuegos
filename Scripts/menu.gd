extends Control

@onready var panel_opciones = $PanelOpciones
@onready var slider_master = $PanelOpciones/VBoxContainer/SliderMaster
@onready var slider_fx = $PanelOpciones/VBoxContainer/SliderFX
@onready var slider_musica = $PanelOpciones/VBoxContainer/SliderMusica
@onready var audio_player = $AudioStreamPlayer

func _ready() -> void:
	_cargar_configuracion()

func _guardar_configuracion() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master", slider_master.value)
	config.set_value("audio", "sfx", slider_fx.value)
	config.set_value("audio", "musica", slider_musica.value)
	config.save("user://settings.cfg")

func _cargar_configuracion() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		slider_master.value = config.get_value("audio", "master", 1.0)
		slider_fx.value = config.get_value("audio", "sfx", 1.0)
		slider_musica.value = config.get_value("audio", "musica", 1.0)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/office.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func juego_nuevo() -> void:
	GameManager.reset_dreams()


func _on_options_pressed() -> void:
	panel_opciones.visible = true

func _on_cerrar_opciones_button_pressed() -> void:
	_guardar_configuracion()
	panel_opciones.visible = false

func _on_slider_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_slider_fx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))	

func _on_slider_musica_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
