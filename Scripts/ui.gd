extends CanvasLayer

@onready var icon = $IconE
@onready var pause_menu = $PauseMenu
@onready var folder = $FolderPanel

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
