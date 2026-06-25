extends Control

@onready var panel_intro: Panel = $PanelContainer/Panel
@onready var panel_phasmo: Panel = $PanelContainer/Panel2
@onready var panel_resultado: Panel = $PanelContainer/Panel3

@onready var vbox: VBoxContainer = $PanelContainer/Panel2/VBoxContainer

@onready var label_titulo1: Label = $HBoxContainer/Label
@onready var label_titulo2: Label = $HBoxContainer/Label2
@onready var label_titulo3: Label = $HBoxContainer/Label3

@onready var label_intro: Label = $PanelContainer/Panel/Label
@onready var label_resultado: Label = $PanelContainer/Panel3/Label

@onready var btn_siguiente: Button = $Button
@onready var btn_anterior: Button = $Button2

const EVIDENCIAS = [
	"Figura reconocible",
	"Emoción dominante",
	"Memoria incompleta",
	"Elemento recurrente",
	"Distorsión espacial",
	"Alteración temporal",
	"Amenaza activa",
	"Objeto fuera de lugar",
	"Presencia no identificada",
	"Voz sin origen",
	"Reflejo incorrecto",
	"Mensaje implícito",
    "Inconsistencia física"
]


const SUEÑOS = {
	"Sueño Ordinario": ["Figura reconocible", "Emoción dominante"],
	"Trauma": ["Figura reconocible", "Emoción dominante", "Memoria incompleta", "Objeto fuera de lugar", "Mensaje implícito"],
	"Bucle": ["Memoria incompleta", "Elemento recurrente", "Distorsión espacial", "Alteración temporal", "Objeto fuera de lugar", "Reflejo incorrecto", "Inconsistencia física"],
	"Sueño Sintomático": ["Emoción dominante", "Memoria incompleta", "Elemento recurrente", "Distorsión espacial", "Amenaza activa", "Voz sin origen", "Reflejo incorrecto", "Inconsistencia física"],
	"Sueño de Persecución": ["Emoción dominante", "Elemento recurrente", "Distorsión espacial", "Amenaza activa", "Presencia no identificada"],
	"Sueño Precognitivo": ["Elemento recurrente", "Distorsión espacial", "Alteración temporal", "Mensaje implícito", "Inconsistencia física"],
	"Sueño de Visitación": ["Figura reconocible", "Emoción dominante", "Objeto fuera de lugar", "Voz sin origen", "Mensaje implícito"],
	"Sueño de Intrusión": ["Amenaza activa", "Objeto fuera de lugar", "Presencia no identificada", "Voz sin origen", "Reflejo incorrecto", "Inconsistencia física"],
	"Sueño Compartido": ["Figura reconocible", "Memoria incompleta", "Elemento recurrente", "Distorsión espacial", "Alteración temporal", "Presencia no identificada", "Mensaje implícito", "Inconsistencia física"]
}

const TITULOS = ["Caso", "Evidencias", "Diagnóstico"]

var evidencias_marcadas: Array = []
var pagActual: int = 0

func _ready() -> void:
	hide()
	var checkboxes = vbox.get_children()
	for i in checkboxes.size():
		checkboxes[i].text = EVIDENCIAS[i]
		checkboxes[i].toggled.connect(_on_checkbox_toggled.bind(EVIDENCIAS[i]))
	
	ir_a_pagina(0)

func ir_a_pagina(pag: int) -> void:
	pagActual = pag
	
	panel_intro.visible = (pag == 0)
	panel_phasmo.visible = (pag == 1)
	panel_resultado.visible = (pag == 2)
	
	# Resaltar título activo
	var titulos = [label_titulo1, label_titulo2, label_titulo3]
	for i in titulos.size():
		titulos[i].text = TITULOS[i]
		if i == pag:
			titulos[i].add_theme_color_override("font_color", Color.WHITE)
		else:
			titulos[i].add_theme_color_override("font_color", Color(1, 1, 1, 0.4))
	
	# Botones
	btn_anterior.visible = pag > 0
	btn_siguiente.visible = pag < 2
	
	# Si va al resultado, calcular diagnóstico
	if pag == 2:
		mostrar_resultado()

func _on_button_pressed() -> void:
	if pagActual < 2:
		ir_a_pagina(pagActual + 1)

func _on_button_2_pressed() -> void:
	if pagActual > 0:
		ir_a_pagina(pagActual - 1)

func _on_checkbox_toggled(marcado: bool, evidencia: String) -> void:
	if marcado and not evidencia in evidencias_marcadas:
		evidencias_marcadas.append(evidencia)
	elif not marcado:
		evidencias_marcadas.erase(evidencia)

func mostrar_resultado() -> void:
	if evidencias_marcadas.is_empty():
		label_resultado.text = "No has marcado ninguna evidencia."
		return
	
	var resultados = []
	
	for tipo in SUEÑOS:
		var requeridas = SUEÑOS[tipo]
		var coincidencias = 0
		for e in evidencias_marcadas:
			if e in requeridas:
				coincidencias += 1
		var score = float(coincidencias) / requeridas.size()
		if score >= 0.5:
			resultados.append({
				"tipo": tipo,
				"score": score,
				"coincidencias": coincidencias,
				"total": requeridas.size()
			})
	
	resultados.sort_custom(func(a, b): return a.score > b.score)
	
	if resultados.is_empty():
		label_resultado.text = "Evidencias insuficientes para diagnosticar."
		return
	
	var texto = "DIAGNÓSTICO PROBABLE:\n\n"
	for i in min(resultados.size(), 3):
		var r = resultados[i]
		var porcentaje = int(r.score * 100)
		texto += "• %s (%d%%)\n" % [r.tipo, porcentaje]
	
	label_resultado.text = texto

func set_info_caso(texto_intro: String) -> void:
	label_intro.text = texto_intro

func reset() -> void:
	evidencias_marcadas.clear()
	for cb in vbox.get_children():
		cb.button_pressed = false
	ir_a_pagina(0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("folder"): 
		self.hide()
