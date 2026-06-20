extends CanvasLayer

@onready var icon = $IconE
@onready var pause_menu = $PauseMenu
@onready var folder = $FolderPanel

func mostrar_interact():
	icon.visible = true

func esconder_interact():
	icon.visible = false

func _input(event):
	if event.is_action_pressed("pausa"):
		pause_menu.visible = !pause_menu.visible
		get_tree().paused = pause_menu.visible
