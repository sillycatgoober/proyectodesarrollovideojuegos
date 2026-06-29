extends CanvasLayer

@onready var icon_panel = $Iconos
@onready var pause_menu = $Pause
@onready var folder = $Journal
@onready var leave_menu = $Warning
@onready var hints = $Hints
@onready var hint_text = $Hints/MarginContainer/RichTextLabel
@onready var guardar_panel = $Guardado
@onready var sprite = $Guardado/Icon
@onready var audio = $AudioStreamPlayer
@onready var icono_e = $Iconos/VBoxContainer/E
@onready var icono_f = $Iconos/VBoxContainer/F
@onready var icono_esc = $Iconos/VBoxContainer/ESC
@onready var icono_scroll = $Iconos/VBoxContainer/Scroll
@onready var blur_pausa: ColorRect = $ColorRect
@onready var label_tit = $Warning/VBoxContainer/RichTextLabel
@onready var label_cont = $Warning/VBoxContainer/RichTextLabel2
@export var menu_audio:AudioStream
@export var folder_audio:AudioStream
@export var guardar_audio:AudioStream

func _ready() -> void:
	icono_e.visible = false
	icono_f.visible = false
	icono_esc.visible = false
	icono_scroll.visible = false
	icon_panel.visible = false

func mostrar_acciones(obj) -> void:
	icono_e.visible = obj.is_in_group("interactuable") and not obj.en_interaccion and obj.tiene_e
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
	if not obj.texto_f.is_empty():
		$Iconos/VBoxContainer/F/Label.text = obj.texto_f
	if icono_scroll.visible:
		$Iconos/VBoxContainer/Scroll/Label.text = obj.texto_scroll
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

func toggle_pausa():
	pause_menu.visible = !pause_menu.visible
	blur_pausa.visible = pause_menu.visible
	audio.stream = menu_audio
	audio.play()
	var bus_idx = AudioServer.get_bus_index("Music")
	if pause_menu.visible:
		var efecto = AudioEffectLowPassFilter.new()
		efecto.cutoff_hz = 500.0
		AudioServer.add_bus_effect(bus_idx, efecto)
	else:
		AudioServer.remove_bus_effect(bus_idx, 0)
	
	actualizar_estado_ui()

func toggle_folder():
	folder.visible = !folder.visible
	audio.stream = folder_audio
	audio.play()
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
	return pause_menu.visible or folder.visible

func actualizar_estado_ui():
	var bloqueando = pause_menu.visible or folder.visible
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

func actualizar_mensaje_pausa() -> void:
	if GameManager.fase_actual == GameManager.Fase.SUENO:
		label_cont.text = "Si sales ahora, perderás el progreso del sueño actual."
		label_tit.text = "Abandonar sueño"
	else:
		label_cont.text = "Tu progreso se guardará desde el último guardado automático."
		label_tit.text = "Volver al menú"

func _input(event):
	if event.is_action_pressed("pausa") and not icono_esc.visible:
		toggle_pausa()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("folder"):
		print("fase",GameManager.fase_actual == GameManager.Fase.SUENO)
		if GameManager.fase_actual == GameManager.Fase.SUENO or DialogManager.dialogo_con_cliente():
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

#BOTONES
func _on_menu_button_pressed() -> void:
	leave_menu.visible = true
	pause_menu.visible = false
	actualizar_mensaje_pausa()

func _on_abandon_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")

func _on_stay_button_pressed() -> void:
	leave_menu.visible = false
	pause_menu.visible = true
#FIN BOTONES
