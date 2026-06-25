extends Node

signal dialogo_actualizado(texto: String, opciones: Array)
signal dialogo_terminado

var dialogos: Dictionary = {}
var npc_actual: String = ""
var nodo_actual: String = ""

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
	emit_signal("dialogo_actualizado", nodo["texto"], nodo["opciones"])
