extends CanvasLayer

@onready var icon_panel = $Iconos
@onready var pause_menu = $PanelOpciones
@onready var folder = $Journal
@onready var icono_e = $Iconos/VBoxContainer/IconE
@onready var icono_f = $Iconos/VBoxContainer/IconF
@onready var icono_esc = $Iconos/VBoxContainer/IconESC
@onready var icono_scroll = $Iconos/VBoxContainer/IconScroll

func mostrar_acciones(obj) -> void:
	icono_e.visible = obj.usa_focus and not obj.en_interaccion
	icono_f.visible = obj.is_in_group("recogible")
	icono_esc.visible = obj.en_interaccion
	icono_scroll.visible = obj.en_interaccion and obj.tiene_scroll
	icon_panel.visible = true

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
