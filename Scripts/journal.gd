extends Control

@onready var panel_caso: Panel = $PanelContainer/Panel
@onready var panel_phasmo: Panel = $PanelContainer/Panel2
@onready var panel_resultado: Panel = $PanelContainer/Panel3
@onready var panel_dreams: Panel = $PanelContainer/Panel4
@onready var panel_opciones: Panel = $PanelContainer/Panel5
@onready var panel_general: Panel = $PanelContainer/Panel5/General
@onready var panel_audio: Panel = $PanelContainer/Panel5/Audio
@onready var panel_controles: Panel = $PanelContainer/Panel5/Controles
@onready var panel_salir: Panel = $PanelContainer/Panel5/Abandonar

@onready var vbox: VBoxContainer = $PanelContainer/Panel2/VBoxContainer
@onready var controles_botones = $PanelContainer/Panel5/Controles/GridContainer

@onready var label_titulo1: Label = $HBoxContainer/Bot1/Label
@onready var label_titulo2: Label = $HBoxContainer/Bot2/Label
@onready var label_titulo3: Label = $HBoxContainer/Bot3/Label
@onready var label_titulo4: Label = $HBoxContainer/Bot4/Label
@onready var label_titulo5: Label = $HBoxContainer/Bot5/Label

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

#VARIABLES OPCIONES
var opciones_actual: int = 0
const PAGINAS_OPCIONES = ["general", "audio", "controles"]
const RESOLUCIONES = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]
const ACCIONES = {
	"interact": "Interactuar",
	"grab": "Recoger",
	"back": "Regresar/Folder",
	"advance": "Avanzar diálogo",
	"move_forward": "Mover adelante",
	"move_backward": "Mover atrás",
	"move_left": "Mover izquierda",
	"move_right": "Mover derecha",
	"run": "Correr"
}
var accion_esperando: String = ""
#FIN VARIABLES OPCIONES

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
	"Sueño Ordinario": ["Presencia identificable","Alteración emocional"],
	"Trauma": ["Presencia identificable","Alteración emocional","Manipulación temporal","Objeto desplazable","Registro del pasado"],
	"Bucle": ["Manipulación temporal","Elemento recurrente","Espacio alterable","Objeto desplazable","Reflejo incorrecto","Inconsistencia física","Voz constante"],
	"Sueño Sintomático": ["Alteración emocional","Elemento recurrente","Espacio alterable","Voz constante","Reflejo incorrecto","Inconsistencia física"],
	"Sueño de Persecución": ["Alteración emocional","Elemento recurrente","Espacio alterable","Amenaza activa","Presencia identificable"],
	"Sueño Precognitivo": ["Elemento recurrente","Espacio alterable","Manipulación temporal","Registro del futuro","Inconsistencia física"],
	"Sueño de Visitación": ["Presencia identificable","Alteración emocional","Objeto desplazable","Voz sin origen","Registro anómalo"],
	"Sueño de Intrusión": ["Objeto desplazable","Presencia identificable","Voz sin origen","Reflejo incorrecto","Inconsistencia física"],
	"Sueño Compartido": ["Presencia identificable","Elemento recurrente","Espacio alterable","Manipulación temporal","Registro compartido","Inconsistencia física"]
}

const TITULOS = ["Caso", "Evidencias", "Diagnóstico","Sueños","Opciones"]
var evidencias_marcadas: Array = []
var pagActual: int = 0
var tab_actual: int = 0
var sueno_actual: int = 0
var lista_suenos: Array = []
var datos_suenos: Dictionary = {}
var datos_clientes: Dictionary = {}

func _ready() -> void:
	visible = false
	_cargar_datos()
	var checkboxes = vbox.get_children()
	for i in checkboxes.size():
		checkboxes[i].text = EVIDENCIAS[i]
		checkboxes[i].toggled.connect(_on_checkbox_toggled.bind(EVIDENCIAS[i]))
	for accion in ACCIONES:
		var boton = controles_botones.get_node(accion)
		boton.pressed.connect(_on_boton_pressed.bind(accion))
	actualizar_botones()
	ir_a_tab(0)

func _cargar_datos() -> void:
	var archivo_clientes = FileAccess.open("res://Assets/Data/clientes.json", FileAccess.READ)
	if archivo_clientes:
		datos_clientes = JSON.parse_string(archivo_clientes.get_as_text())
		archivo_clientes.close()
	
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
	panel_opciones.visible = (tab == 4)
	audio.stream = sonido_tab
	audio.play()
	
	var titulos = [label_titulo1, label_titulo2, label_titulo3, label_titulo4]
	for i in titulos.size():
		titulos[i].text = TITULOS[i]
		if i == tab:
			titulos[i].add_theme_color_override("font_color", Color.WHITE)
		else:
			titulos[i].add_theme_color_override("font_color", Color(1, 1, 1, 0.4))
	
	btn_anterior.visible = (tab == 3 and sueno_actual > 0) or (tab == 4 and opciones_actual > 0)
	btn_siguiente.visible = (tab == 3 and sueno_actual < lista_suenos.size() - 1) or (tab == 4 and opciones_actual < PAGINAS_OPCIONES.size() - 1)
	
	if tab == 0:
		mostrar_caso()
	if tab == 2:
		mostrar_resultado()
	if tab == 3:
		mostrar_sueno(sueno_actual)
	if tab == 4:
		opciones_actual = 0
		mostrar_opciones(0)

func mostrar_sueno(index: int) -> void:
	if lista_suenos.is_empty():
		return
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

func mostrar_opciones(index: int):
	opciones_actual = index
	panel_general.visible = (index == 0)
	panel_audio.visible = (index == 1)
	panel_controles.visible = (index == 2)
	btn_anterior.visible = index > 0
	btn_siguiente.visible = index < PAGINAS_OPCIONES.size() - 1

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
	if tab_actual == 3 or tab_actual == 4:
		audio.stream = sonidos_hojas.pick_random()
		audio.play()
	if tab_actual == 3:
		sueno_actual += 1
		mostrar_sueno(sueno_actual)
		btn_anterior.visible = true
		btn_siguiente.visible = sueno_actual < lista_suenos.size() - 1
	if tab_actual == 4:
		opciones_actual += 1
		mostrar_opciones(opciones_actual)

func _on_button_2_pressed() -> void:
	if tab_actual == 3 or tab_actual == 4:
		audio.stream = sonidos_hojas.pick_random()
		audio.play()
	if tab_actual == 3:
		sueno_actual -= 1
		mostrar_sueno(sueno_actual)
		btn_siguiente.visible = true
		btn_anterior.visible = sueno_actual > 0
	if tab_actual == 4:
		opciones_actual -= 1
		mostrar_opciones(opciones_actual)

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
	ir_a_tab(0)

func _on_bot_1_pressed() -> void:
	ir_a_tab(0)
func _on_bot_2_pressed() -> void:
	ir_a_tab(1)
func _on_bot_3_pressed() -> void:
	ir_a_tab(2)
func _on_bot_4_pressed() -> void:
	ir_a_tab(3)
func _on_bot_5_pressed() -> void:
	ir_a_tab(4)

#region OPCIONES
#GENERAL
func _on_res_bot_item_selected(index: int) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(RESOLUCIONES[index])
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
func _on_idioma_bot_item_selected(index: int) -> void:
	pass
func _on_reticula_toggled(toggled_on: bool) -> void:
	pass
func _on_close_button_pressed() -> void:
	pass # Replace with function body.
func _on_menu_button_pressed() -> void:
	panel_salir.visible = true
	panel_general.visible = false
	actualizar_mensaje_pausa()
func actualizar_mensaje_pausa() -> void:
	if GameManager.fase_actual == GameManager.Fase.SUENO:
		$PanelContainer/Panel5/Abandonar/VBoxContainer/Cont.text = "Si sales ahora, perderás el progreso del sueño actual."
		$PanelContainer/Panel5/Abandonar/VBoxContainer/Tit.text = "Abandonar sueño"
	else:
		$PanelContainer/Panel5/Abandonar/VBoxContainer/Cont.text = "Tu progreso se guardará desde el último guardado automático."
		$PanelContainer/Panel5/Abandonar/VBoxContainer/Tit.text = "Volver al menú"
func _on_abandon_button_pressed() -> void:
	UI.reset_estado()
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")
	panel_salir.visible = false
	panel_general.visible = true
func _on_stay_button_pressed() -> void:
	panel_salir.visible = false
	panel_general.visible = true
#AUDIO
func _on_slider_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
func _on_slider_fx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
func _on_slider_musica_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

#CONTROLES
func actualizar_botones() -> void:
	for accion in ACCIONES:
		var boton = controles_botones.get_node(accion)
		var label = boton.get_node("Label")
		var eventos = InputMap.action_get_events(accion)
		if eventos.size() > 0:
			if eventos[0] is InputEventKey:
				label.text = OS.get_keycode_string(eventos[0].physical_keycode)
			else:
				label.text = eventos[0].as_text()
func _on_boton_pressed(accion: String) -> void:
	if accion_esperando != "":
		actualizar_botones()
	accion_esperando = accion
	controles_botones.get_node(accion).get_node("Label").text = "..."
func _input(event: InputEvent) -> void:
	if accion_esperando == "":
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			accion_esperando = ""
			actualizar_botones()
			get_viewport().set_input_as_handled()
			return
		InputMap.action_erase_events(accion_esperando)
		InputMap.action_add_event(accion_esperando, event)
		actualizar_botones()
		accion_esperando = ""
		guardar_controles()
		get_viewport().set_input_as_handled()
func guardar_controles() -> void:
	var config = ConfigFile.new()
	config.load("user://settings.cfg")  # carga lo que ya hay para no borrar audio
	for accion in ACCIONES:
		var eventos = InputMap.action_get_events(accion)
		if eventos.size() > 0:
			config.set_value("controles", accion, eventos[0].as_text())
	config.save("user://settings.cfg")
#endregion
