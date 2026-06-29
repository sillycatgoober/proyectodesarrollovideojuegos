extends Control

# Ruta a tu JSON de resultados
const RUTA_JSON = "res://Assets/Data/resultados.json"

# Referencias a tus nodos
@onready var panel_resumen = $PanelContainer/Panelresultados
@onready var panel_gracias = $PanelContainer/PanelGracias
@onready var label_mensaje = $PanelContainer/Panelresultados/Resumen/Margin/CenterContainer/VBoxContainer/labeljson
@onready var btn_continuar = $PanelContainer/Panelresultados/Resumen/Margin/ContButton
@onready var btn_menu = $PanelContainer/PanelGracias/botonMenu

func _ready() -> void:
	# Configuración inicial: mostrar resumen, ocultar gracias
	panel_resumen.visible = true
	panel_gracias.visible = false
	
	# Cargar el resultado desde el GameManager
	cargar_resultado(GameManager.resultado_final)
	
	# Conexión de botones
	btn_continuar.pressed.connect(_on_continuar_pressed)
	btn_menu.pressed.connect(_on_menu_pressed)

func cargar_resultado(tipo: String) -> void:
	var archivo = FileAccess.open(RUTA_JSON, FileAccess.READ)
	if archivo:
		var datos = JSON.parse_string(archivo.get_as_text())
		archivo.close()
		
		# Validar y asignar texto
		if datos.has(tipo):
			label_mensaje.text = datos[tipo]
		else:
			label_mensaje.text = "Error al cargar el diagnóstico."

func _on_continuar_pressed() -> void:
	# Cambiar visibilidad de paneles
	panel_resumen.visible = false
	panel_gracias.visible = true

func _on_menu_pressed() -> void:
	# Regresar al menú principal
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")
