extends CanvasLayer
@onready var resumen_panel = $Resumen
@onready var dia = $Dia
@onready var label_dia = $Dia/HBoxContainer/Label2
var reportes = {}
@onready var titulo = $Resumen/Margin/VBox/titulo
@onready var resumen = $Resumen/Margin/VBox/resumen
@onready var resultado = $Resumen/Margin/VBox/resultado
@onready var evaluacion = $Resumen/Margin/VBox/evaluacion
@onready var superiores = $Resumen/Margin/VBox/superiores

func _ready() -> void:
	cargar_reportes()
	dia.visible = false
	label_dia.text = "Día " + str(GameManager.dream_actual)
	await get_tree().create_timer(5.0).timeout

func _on_button_pressed() -> void:
	GameManager.fase_actual = GameManager.Fase.ENTREVISTA
	get_tree().change_scene_to_file("res://Scenes/office.tscn")

func _on_cont_button_pressed() -> void:
	resumen_panel.visible = false
	dia.visible = true

#---- RESULTADOS ----#
func cargar_reportes():
	var file = FileAccess.open("res://Assets/Data/resultados.json", FileAccess.READ)
	if file:
		reportes = JSON.parse_string(file.get_as_text())
		file.close()
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
	titulo.text = reporte["titulo"]
	resumen.text = reporte["resumen"]
	resultado.text = reporte["resultado"]
	evaluacion.text = reporte["evaluacion"]
	superiores.text = reporte["superiores"]
func mostrar_final(es_correcto: bool, nombre: String, dia: int):
	var reporte = generar_reporte(es_correcto, nombre, dia)
	mostrar_reporte(reporte)
#---- FIN RESULTADOS ----#
