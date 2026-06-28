extends Node
enum Fase {INTRO, ENTREVISTA, SUENO, DIAGNOSTICO}
var fase_actual: Fase = Fase.INTRO
var clientes: Dictionary = {}
var nombre_cliente_actual: String = ""
var dream_actual := 1
var slot_actual:int
var sub_fase: String = ""
var diagnostico_final: String = ""

var dreams = {
	1: {"done": false, "diagnostico_correcto": false},
	2: {"done": false, "diagnostico_correcto": false},
	3: {"done": false, "diagnostico_correcto": false},
	4: {"done": false, "diagnostico_correcto": false},
	5: {"done": false, "diagnostico_correcto": false}
}

func _ready() -> void:
	_cargar_clientes()

func reset_dreams():
	dream_actual = 1
	var dreams = {
		1: {"done": false, "diagnostico_correcto": false},
		2: {"done": false, "diagnostico_correcto": false},
		3: {"done": false, "diagnostico_correcto": false},
		4: {"done": false, "diagnostico_correcto": false},
		5: {"done": false, "diagnostico_correcto": false}
	}

#---- CLIENTES ----#
func _cargar_clientes() -> void:
	var archivo = FileAccess.open("res://Assets/Data/clientes.json", FileAccess.READ)
	if archivo:
		clientes = JSON.parse_string(archivo.get_as_text())
		archivo.close()

func actualizar_cliente() -> void:
	var id = "cliente" + str(dream_actual)
	if id in clientes:
		nombre_cliente_actual = clientes[id].nombre
#---- FIN CLIENTES ----#

#---- DIAGNOSTICO ----#
func diagnostico_correcto_actual() -> String:
	var id = "cliente" + str(dream_actual)
	if id in clientes:
		return clientes[id].dream
	return ""
#---- FIN DIAGNOSTICO ----#

#---- GUARDADO ----#
func guardar(slot: int = -1) -> void:
	if slot != -1:
		slot_actual = slot
	var data = {
		"dreams": dreams,
		"dream_actual": dream_actual
	}
	var file = FileAccess.open("user://savegame_" + str(slot_actual) + ".dat", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))

func cargar(slot: int = 1) -> void:
	var path = "user://savegame_" + str(slot) + ".dat"
	if not FileAccess.file_exists(path):
		return
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data:
			dreams = data.dreams
			dream_actual = data.dream_actual

func hay_partida_guardada(slot: int = 1) -> bool:
	return FileAccess.file_exists("user://savegame_" + str(slot) + ".dat")

func eliminar_partida(slot: int) -> void:
	var path = "user://savegame_" + str(slot) + ".dat"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

#---- FIN GUARDADO ----#
