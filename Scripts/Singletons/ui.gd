extends CanvasLayer

@onready var icon = $IconE
@onready var pause_menu = $PauseMenu
@onready var folder = $FolderPanel
@onready var texto_mensaje = $TextoMensaje # <--- NUEVO

func mostrar_interact():
	icon.visible = true

func esconder_interact():
	icon.visible = false

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
	if event.is_action_pressed("pausa"):
		abrir_pause()

# --- NUEVAS FUNCIONES PARA LA CAJA FUERTE ---
func mostrar_texto(texto_nuevo: String) -> void:
	if texto_mensaje != null:
		texto_mensaje.text = texto_nuevo
		texto_mensaje.show()
	else:
		print("TEXTO INTERFAZ: ", texto_nuevo)

func ocultar_texto() -> void:
	if texto_mensaje != null:
		texto_mensaje.hide()
