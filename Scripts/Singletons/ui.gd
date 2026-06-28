extends CanvasLayer

@onready var icon_panel = $Iconos
@onready var pause_menu = $Pause
@onready var folder = $Journal
@onready var icono_e = $Iconos/VBoxContainer/E
@onready var icono_f = $Iconos/VBoxContainer/F
@onready var icono_esc = $Iconos/VBoxContainer/ESC
@onready var icono_scroll = $Iconos/VBoxContainer/Scroll

func _ready() -> void:
	icono_e.visible = false
	icono_f.visible = false
	icono_esc.visible = false
	icono_scroll.visible = false
	icon_panel.visible = false

func mostrar_acciones(obj) -> void:
	icono_e.visible = obj.is_in_group("interactuable") and not obj.en_interaccion
	icono_f.visible = obj.is_in_group("recogible")
	icono_esc.visible = obj.en_interaccion
	icono_scroll.visible = obj.en_interaccion and obj.tiene_scroll
	icon_panel.visible = true
	#labels
	if obj.usa_focus and not obj.en_interaccion:
		$Iconos/VBoxContainer/E/Label.text = "Observar"
	else:
		$Iconos/VBoxContainer/E/Label.text = "Interactuar"
	if obj.is_in_group("ticket"):
		var asientos_manager = get_tree().get_first_node_in_group("asientos_manager")
		if asientos_manager and asientos_manager.ticket_en_mano != null:
			$Iconos/VBoxContainer/F/Label.text = "Intercambiar"
		else:
			$Iconos/VBoxContainer/F/Label.text = "Recoger"
	if not obj.texto_e.is_empty():
		$Iconos/VBoxContainer/E/Label.text = obj.texto_e
	if icono_scroll.visible:
		$Iconos/VBoxContainer/Scroll/Label.text = obj.texto_scroll

func esconder_acciones() -> void:
	icon_panel.visible = false

func toggle_pausa():
	pause_menu.visible = !pause_menu.visible
	print(pause_menu.visible)
	actualizar_estado_ui()

func toggle_folder():
	folder.visible = !folder.visible
	print(folder.visible)
	actualizar_estado_ui()

func esta_bloqueando_juego() -> bool:
	return pause_menu.visible or folder.visible

func actualizar_estado_ui():
	var bloqueando = pause_menu.visible or folder.visible
	if bloqueando:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		esconder_acciones()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.puede_moverse = !bloqueando

func _input(event):
	if event.is_action_pressed("pausa") and not icono_esc.visible:
		toggle_pausa()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("folder"):
		toggle_folder()
		get_viewport().set_input_as_handled()

func _on_close_button_pressed() -> void:
	toggle_pausa()
	GameManager.guardar_config()

func _on_slider_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_slider_fx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func _on_slider_musica_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
