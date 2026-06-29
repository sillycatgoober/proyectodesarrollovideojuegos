extends Control

@onready var panel_caso: Panel = $PanelContainer/Panel
@onready var panel_phasmo: Panel = $PanelContainer/Panel2
@onready var panel_resultado: Panel = $PanelContainer/Panel3
@onready var panel_dreams: Panel = $PanelContainer/Panel4

@onready var vbox: VBoxContainer = $PanelContainer/Panel2/VBoxContainer

@onready var label_titulo1: Label = $HBoxContainer/Bot1/Label
@onready var label_titulo2: Label = $HBoxContainer/Bot2/Label
@onready var label_titulo3: Label = $HBoxContainer/Bot3/Label
@onready var label_titulo4: Label = $HBoxContainer/Bot4/Label

@onready var label_resultado: Label = $PanelContainer/Panel3/Label
@onready var label_caso: Label = $PanelContainer/Panel/VBox/Caso
@onready var label_nombre: Label = $PanelContainer/Panel/VBox/Nombre
@onready var label_edad: Label = $PanelContainer/Panel/VBox/Edad
@onready var label_ocu: Label = $PanelContainer/Panel/VBox/Ocupacion
@onready var label_motivo: Label = $PanelContainer/Panel/VBox/Motivo
@onready var label_dream: Label = $PanelContainer/Panel4/VBox/Nombre
@onready var label_dream_desc: Label = $PanelContainer/Panel4/VBox/Desc
@onready var label_dream_sol: Label = $PanelContainer/Panel4/VBox/Solucion
@onready var label_dream_ev: Label = $PanelContainer/Panel4/VBox/Evidencias

@onready var audio = $AudioStreamPlayer
@export var sonidos_hojas : Array[AudioStream]
@export var sonido_tab : AudioStream

@onready var btn_siguiente: TextureButton = $Button
@onready var btn_anterior: TextureButton = $Button2

const EVIDENCIAS = [
	"Presencia identificable",
	"Alteración emocional",
	"Manipulación temporal",
	"Objeto desplazable",
	"Registro del pasado",
	"Manipulación temporal",
	"Elemento recurrente",
	"Espacio alterable",
	"Reflejo incorrecto",
	"Inconsistencia física",
	"Voz constante",
	"Amenaza activa",
	"Registro del futuro",
	"Registro anómalo",
	"Registro compartido"
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

const TITULOS = ["Caso", "Evidencias", "Diagnóstico","Sueños"]
var evidencias_marcadas: Array = []
var pagActual: int = 0
var tab_actual: int = 0
var sueno_actual: int = 0
var lista_suenos: Array = []
var datos_suenos: Dictionary = {}
var datos_clientes: Dictionary = {}

func _ready() -> void:
	hide()
	_cargar_datos()
	var checkboxes = vbox.get_children()
	for i in checkboxes.size():
		checkboxes[i].text = EVIDENCIAS[i]
		checkboxes[i].toggled.connect(_on_checkbox_toggled.bind(EVIDENCIAS[i]))
	ir_a_tab(0)

func _cargar_datos() -> void:
	# clientes
	var archivo_clientes = FileAccess.open("res://Assets/Data/clientes.json", FileAccess.READ)
	if archivo_clientes:
		datos_clientes = JSON.parse_string(archivo_clientes.get_as_text())
		archivo_clientes.close()
	
	# sueños
	var archivo_suenos = FileAccess.open("res://Assets/Data/manual.json", FileAccess.READ)
	if archivo_suenos:
		var data = JSON.parse_string(archivo_suenos.get_as_text())
		datos_suenos = data.dreams
		lista_suenos = datos_suenos.keys()
		archivo_suenos.close()

func ir_a_tab(tab: int) -> void:
	tab_actual = tab
	panel_caso.visible = (tab == 0)
	panel_phasmo.visible = (tab == 1)
	panel_resultado.visible = (tab == 2)
	panel_dreams.visible = (tab == 3)
	audio.stream = sonido_tab
	audio.play()
	
	var titulos = [label_titulo1, label_titulo2, label_titulo3, label_titulo4]
	for i in titulos.size():
		titulos[i].text = TITULOS[i]  # ← faltaba esto
		if i == tab:
			titulos[i].add_theme_color_override("font_color", Color.WHITE)
		else:
			titulos[i].add_theme_color_override("font_color", Color(1, 1, 1, 0.4))
	
	btn_anterior.visible = (tab == 3 and sueno_actual > 0)
	btn_siguiente.visible = (tab == 3 and sueno_actual < lista_suenos.size() - 1)
	
	if tab == 0:
		mostrar_caso()
	if tab == 2:
		mostrar_resultado()
	if tab == 3:
		mostrar_sueno(sueno_actual)

func ir_a_pagina(pag: int) -> void:
	pagActual = pag
	
	panel_caso.visible = (pag == 0)
	panel_phasmo.visible = (pag == 1)
	panel_resultado.visible = (pag == 2)
	panel_dreams.visible = (pag == 3)
	
	var titulos = [label_titulo1,label_titulo2,label_titulo3,label_titulo4]
	for i in titulos.size():
		titulos[i].text = TITULOS[i]
		if i == pag:
			titulos[i].add_theme_color_override("font_color", Color.WHITE)
		else:
			titulos[i].add_theme_color_override("font_color", Color(1, 1, 1, 0.4))
	
	btn_anterior.visible = pag > 0
	btn_siguiente.visible = pag < 2
	
	if pag == 2:
		mostrar_resultado()

func mostrar_sueno(index: int) -> void:
	if lista_suenos.is_empty():
		return
	audio.stream = sonidos_hojas.pick_random()
	audio.play()
	var nombre = lista_suenos[index]
	var datos = datos_suenos[nombre]
	
	label_dream.text = nombre
	label_dream_desc.text = datos.descripcion
	label_dream_sol.text = "Solución: " + datos.solucion
	
	var ev_texto = "Evidencias:\n"
	for e in datos.evidencias:
		ev_texto += "• " + e + "\n"
	label_dream_ev.text = ev_texto
	
	btn_anterior.visible = index > 0
	btn_siguiente.visible = index < lista_suenos.size() - 1

func mostrar_caso() -> void:
	var id = "cliente" + str(GameManager.dream_actual)
	if id not in datos_clientes:
		return
	var cliente = datos_clientes[id]
	
	label_caso.text = "Caso #" + cliente.caso
	label_nombre.text = "Nombre: " + cliente.nombre
	label_edad.text = "Edad: " + cliente.edad
	label_ocu.text = "Ocupación: " + cliente.ocupacion
	label_motivo.text = "Notas: " + cliente.motivo

func _on_button_pressed() -> void:
	if tab_actual == 3:
		sueno_actual += 1
		mostrar_sueno(sueno_actual)
		btn_anterior.visible = true
		btn_siguiente.visible = sueno_actual < lista_suenos.size() - 1

func _on_button_2_pressed() -> void:
	if tab_actual == 3:
		sueno_actual -= 1
		mostrar_sueno(sueno_actual)
		btn_siguiente.visible = true
		btn_anterior.visible = sueno_actual > 0

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

func reset() -> void:
	evidencias_marcadas.clear()
	for cb in vbox.get_children():
		cb.button_pressed = false
	ir_a_pagina(0)

func _on_bot_1_pressed() -> void:
	ir_a_tab(0)
func _on_bot_2_pressed() -> void:
	ir_a_tab(1)
func _on_bot_3_pressed() -> void:
	ir_a_tab(2)
func _on_bot_4_pressed() -> void:
	ir_a_tab(3)
