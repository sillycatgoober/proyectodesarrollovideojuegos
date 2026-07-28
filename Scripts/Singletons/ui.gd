extends CanvasLayer

@onready var icon_panel = $Iconos
@onready var folder = $Journal
@onready var hints = $Hints
@onready var hint_text = $Hints/MarginContainer/RichTextLabel
@onready var guardar_panel = $Guardado
@onready var sprite = $Guardado/Icon
@onready var audio = $AudioStreamPlayer
@onready var icono_e = $Iconos/VBoxContainer/E
@onready var icono_f = $Iconos/VBoxContainer/F
@onready var icono_esc = $Iconos/VBoxContainer/ESC
@onready var icono_scroll = $Iconos/VBoxContainer/Scroll
@onready var icono_click = $Iconos/VBoxContainer/Click
@onready var blur_pausa: ColorRect = $ColorRect
@export var folder_audio:AudioStream
@export var guardar_audio:AudioStream

func _ready() -> void:
	icono_e.visible = false
	icono_f.visible = false
	icono_esc.visible = false
	icono_scroll.visible = false
	icono_click.visible = false
	icon_panel.visible = false

func mostrar_acciones(obj) -> void:
	icono_e.visible = obj.is_in_group("interactuable") and not obj.en_interaccion and obj.tiene_e
	icono_f.visible = obj.is_in_group("recogible")
	icono_esc.visible = obj.en_interaccion
	icono_scroll.visible = obj.en_interaccion and obj.tiene_scroll
	icono_click.visible = obj.en_interaccion and obj.tiene_click
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
	if not obj.texto_f.is_empty():
		$Iconos/VBoxContainer/F/Label.text = obj.texto_f
	if icono_scroll.visible:
		$Iconos/VBoxContainer/Scroll/Label.text = obj.texto_scroll
	if icono_click.visible:
		$Iconos/VBoxContainer/Click/Label.text = obj.texto_click
	if icono_esc.visible and not obj.texto_esc=="":
		$Iconos/VBoxContainer/ESC/Label.text = obj.texto_esc

func esconder_acciones() -> void:
	icon_panel.visible = false

func set_hints(texto:String):
	hints.modulate.a = 0.0
	hints.visible = true
	hint_text.text = texto
	
	var tween = create_tween()
	tween.tween_property(hints, "modulate:a", 1.0, 0.5)
	tween.tween_interval(3.0)
	tween.tween_property(hints, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): hints.visible = false)

func toggle_folder():
	folder._cargar_datos()
	folder.visible = !folder.visible
	blur_pausa.visible = folder.visible
	audio.stream = folder_audio
	audio.play()
	var bus_idx = AudioServer.get_bus_index("Music")
	if folder.visible:
		var efecto = AudioEffectLowPassFilter.new()
		efecto.cutoff_hz = 500.0
		AudioServer.add_bus_effect(bus_idx, efecto)
	else:
		AudioServer.remove_bus_effect(bus_idx, 0)
	
	actualizar_estado_ui()

func guardado():
	audio.stream = guardar_audio
	audio.play()
	guardar_panel.modulate.a = 0.0
	guardar_panel.visible = true
	sprite.play()
	
	var tween = create_tween()
	tween.tween_property(guardar_panel, "modulate:a", 1.0, 0.5)
	tween.tween_interval(1.5)
	tween.tween_property(guardar_panel, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): guardar_panel.visible = false)

func esta_bloqueando_juego() -> bool:
	return folder.visible

func actualizar_estado_ui():
	var bloqueando = folder.visible
	if bloqueando:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		esconder_acciones()
	else:
		var escena = get_tree().current_scene
		if escena.has_method("usa_cursor_libre") and escena.usa_cursor_libre():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.puede_moverse = !bloqueando


func reset_estado() -> void:
	folder.visible = false
	blur_pausa.visible = false
	var bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_idx, 0, false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event.is_action_pressed("back") and not icono_esc.visible:
		toggle_folder()
		get_viewport().set_input_as_handled()

func _on_close_button_pressed() -> void:
	#toggle_pausa()
	GameManager.guardar_config()

func _on_slider_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_slider_fx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func _on_slider_musica_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
