extends Node

signal dialogo_actualizado(quien: String, texto: String, opciones: Array)
signal dialogo_terminado

var dialogos: Dictionary = {}
var npc_actual: String = ""
var nodo_actual: String = ""
var lineas_actuales: Array = []
var linea_index: int = 0

func _ready() -> void:
	_cargar_dialogos()

func _cargar_dialogos() -> void:
	var archivo = FileAccess.open("res://Assets/Data/dialogos.json", FileAccess.READ)
	if archivo:
		dialogos = JSON.parse_string(archivo.get_as_text())
		archivo.close()
	else:
		print("ERROR: No se encontró dialogos.json")

func iniciar_dialogo(npc: String) -> void:
	npc_actual = npc
	nodo_actual = "inicio"
	_mostrar_nodo_actual()

func avanzar() -> void:
	# avanza líneas si hay pendientes
	if lineas_actuales.size() > 0 and linea_index < lineas_actuales.size() - 1:
		linea_index += 1
		_emitir_linea(lineas_actuales[linea_index])
		return
	
	# terminaron las líneas, ve al siguiente nodo
	var nodo = dialogos[npc_actual][nodo_actual]
	if "siguiente" in nodo:
		var siguiente = nodo["siguiente"]
		if siguiente == "fin":
			emit_signal("dialogo_terminado")
			return
		nodo_actual = siguiente
		_mostrar_nodo_actual()

func elegir_opcion(indice: int) -> void:
	var nodo = dialogos[npc_actual][nodo_actual]
	var siguiente = nodo["opciones"][indice]["siguiente"]
		
	if siguiente == "fin":
		emit_signal("dialogo_terminado")
		return
	
	nodo_actual = siguiente
	_mostrar_nodo_actual()

func _mostrar_nodo_actual() -> void:
	var nodo = dialogos[npc_actual][nodo_actual]
	
	if "lineas" in nodo:
		lineas_actuales = nodo["lineas"]
		linea_index = 0
		_emitir_linea(lineas_actuales[0])
	elif "texto" in nodo:
		lineas_actuales = []
		var partes = _separar_quien(nodo["texto"])
		emit_signal("dialogo_actualizado", partes[0], partes[1], nodo.get("opciones", []))

func _emitir_linea(linea: String) -> void:
	var partes = _separar_quien(linea)
	emit_signal("dialogo_actualizado", partes[0], partes[1], [])

func _separar_quien(texto: String) -> Array:
	if ": " in texto:
		var partes = texto.split(": ", true, 1)
		return [partes[0], partes[1]]
	return ["", texto]
