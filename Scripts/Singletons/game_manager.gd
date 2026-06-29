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
	"1": {"done": false, "diagnostico_correcto": false},
	"2": {"done": false, "diagnostico_correcto": false},
	"3": {"done": false, "diagnostico_correcto": false},
	"4": {"done": false, "diagnostico_correcto": false},
	"5": {"done": false, "diagnostico_correcto": false}
}

func _ready() -> void:
	cargar_config()
	_cargar_clientes()

func reset_dreams():
	dream_actual = 1
	dreams = {
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
	print("=== GUARDANDO ===")
	print("Fase:", fase_actual)
	print("Escena:", get_tree().current_scene.scene_file_path)
	if slot != -1:
		slot_actual = slot
	var data = {
		"dreams": dreams,
		"dream_actual": dream_actual,
		"fase_actual": fase_actual,
		"escena": get_tree().current_scene.scene_file_path
	}
	var file = FileAccess.open("user://savegame_" + str(slot_actual) + ".dat", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
	UI.guardado()

func cargar(slot: int = 1) -> void:
	var path = "user://savegame_" + str(slot) + ".dat"
	if not FileAccess.file_exists(path):
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data:
			slot_actual = slot
			dreams = data.get("dreams", dreams)
			dream_actual = data.get("dream_actual", 1)
			fase_actual = data.get("fase_actual", Fase.INTRO)
			var escena = data.get("escena", "res://Scenes/office.tscn")
			get_tree().call_deferred("change_scene_to_file", escena)

func hay_partida_guardada(slot: int = 1) -> bool:
	return FileAccess.file_exists("user://savegame_" + str(slot) + ".dat")

func eliminar_partida(slot: int) -> void:
	var path = "user://savegame_" + str(slot) + ".dat"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

#---- FIN GUARDADO ----#

#---- CONFIGURACION AUDIO ----#
func guardar_config() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	config.set_value("audio", "sfx", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	config.set_value("audio", "musica", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	config.save("user://settings.cfg")

func cargar_config() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), config.get_value("audio", "master", 0.0))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), config.get_value("audio", "sfx", 0.0))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), config.get_value("audio", "musica", 0.0))
#---- FIN CONFIGURACION AUDIO ----#


func set_gameplay_mode():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func set_ui_mode():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
