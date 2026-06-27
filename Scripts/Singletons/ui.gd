extends CanvasLayer

@onready var icon_panel = $Iconos
@onready var pause_menu = $PanelOpciones
@onready var folder = $Journal
@onready var icono_e = $Iconos/VBoxContainer/E
@onready var icono_f = $Iconos/VBoxContainer/F
@onready var icono_esc = $Iconos/VBoxContainer/ESC
@onready var icono_scroll = $Iconos/VBoxContainer/Scroll

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

func abrir_folder():
	folder.show()

func cerrar_folder():
	folder.hide()

func abrir_pause():
	pause_menu.show()
	get_tree().paused = true

func cerrar_pause():
	pause_menu.hide()
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("pausa") and not icono_esc.visible:
		abrir_pause()

# --- NUEVAS FUNCIONES PARA LA CAJA FUERTE ---
#func mostrar_texto(texto_nuevo: String) -> void:
	#if texto_mensaje != null:
		#texto_mensaje.text = texto_nuevo
		#texto_mensaje.show()
	#else:
		#print("TEXTO INTERFAZ: ", texto_nuevo)
#
#func ocultar_texto() -> void:
	#if texto_mensaje != null:
		#texto_mensaje.hide()
