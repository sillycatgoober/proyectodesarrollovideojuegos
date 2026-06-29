extends CanvasLayer

# Ruta a tu JSON de resultados
const RUTA_JSON = "res://Assets/Data/resultados.json"

# Referencias a tus nodos
@onready var panel_resumen = $Resultados
@onready var panel_gracias = $PanelGracias
@onready var label_mensaje = $Resultados/Margin/VBox/labeljson
@onready var btn_continuar = $Resultados/Margin/VBox/ContButton
@onready var titulo = $Resultados/Margin/VBox/titulo
@onready var resumen = $Resultados/Margin/VBox/resumen
@onready var resultado = $Resultados/Margin/VBox/resultado
@onready var evaluacion = $Resultados/Margin/VBox/evaluacion
@onready var superiores = $Resultados/Margin/VBox/superiores
var reportes = {}

func _ready() -> void:
	panel_resumen.visible = true
	panel_gracias.visible = false
	cargar_reportes()
	var puntaje = GameManager.calcular_puntaje()
	mostrar_final(puntaje.evaluacion)

func cargar_resultado(tipo: String) -> void:
	var archivo = FileAccess.open(RUTA_JSON, FileAccess.READ)
	if archivo:
		var datos = JSON.parse_string(archivo.get_as_text())
		archivo.close()
		if datos.has(tipo):
			label_mensaje.text = datos[tipo]
		else:
			label_mensaje.text = "Error al cargar el diagnóstico."

func _on_abandon_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")


#---- RESULTADOS ----#
func mostrar_final(evaluacion: String) -> void:
	var reporte = reportes[evaluacion]
	await mostrar_reporte(reporte)

func cargar_reportes():
	var file = FileAccess.open("res://Assets/Data/resultadosnose.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()

		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY:
			reportes = result
		else:
			push_error("JSON inválido en resultados.json")
func aplicar_template(texto: String, data: Dictionary) -> String:
	for key in data.keys():
		texto = texto.replace("{" + key + "}", str(data[key]))
	return texto
func generar_reporte(es_correcto: bool, nombre: String, dia: int) -> Dictionary:
	var tipo = "correcto" if es_correcto else "incorrecto"
	var base = reportes[tipo]
	var data = {
		"nombre": nombre,
		"dia": dia
	}
	return {
		"titulo": aplicar_template(base["titulo"], data),
		"resumen": aplicar_template(base["resumen"], data),
		"resultado": aplicar_template(base["resultado"], data),
		"evaluacion": aplicar_template(base["evaluacion"], data),
		"superiores": aplicar_template(base["superiores"], data)
	}
func mostrar_reporte(reporte: Dictionary):
	await titulo.mostrar_texto(reporte["titulo"])
	await resumen.mostrar_texto(reporte["resumen"])
	await resultado.mostrar_texto(reporte["resultado"])
	await evaluacion.mostrar_texto(reporte["evaluacion"])
	await superiores.mostrar_texto(reporte["superiores"])
#---- FIN RESULTADOS ----#


func _on_cont_button_pressed() -> void:
	panel_resumen.visible = false
	panel_gracias.visible = true
