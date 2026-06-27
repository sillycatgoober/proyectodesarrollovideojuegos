extends Node
enum Fase {INTRO, ENTREVISTA, SUENO, DIAGNOSTICO}
var fase_actual: Fase = Fase.INTRO
var clientes: Dictionary = {}
var nombre_cliente_actual: String = ""
var dream_actual := 1
var dreams = {
	1: {"done": false},
	2: {"done": false},
	3: {"done": false},
	4: {"done": false},
	5: {"done": false}
}

func _ready() -> void:
	_cargar_clientes()

func reset_dreams():
	dream_actual = 1
	dreams = {
		1: {"done": false},
		2: {"done": false},
		3: {"done": false},
		4: {"done": false},
		5: {"done": false}
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

#---- GUARDADO ----#
func guardar():
	var data = {
		"dreams": dreams,
		"dream_actual": dream_actual
	}
	var file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))

func cargar():
	if not FileAccess.file_exists("user://savegame.dat"):
		return
	var file = FileAccess.open("user://savegame.dat", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data:
			dreams = data.dreams
			dream_actual = data.dream_actual

func hay_partida_guardada() -> bool:
	return FileAccess.file_exists("user://savegame.dat")

#---- FIN GUARDADO ----#
