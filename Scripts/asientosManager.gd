extends Node3D

@export var ticket_escena: PackedScene
@export var asiento_vacio_escena: PackedScene
var entidad: Node3D
var asiento_vacio_nodo = null
var asiento_de_origen: String = ""
signal todos_correctos
signal entidad_colocada

var datos_asientos = [
{id="1A", pos=Vector3(4.295,1.083,-1.94), ticket_correcto="10B", ticket_actual="1A", nombre="Patricia León", desc="Siempre 10B"},
{id="1B", pos=Vector3(4.295,1.083,0.857), ticket_correcto="4A", ticket_actual="1B", nombre="Laura Salas", desc="Donde fuera, pero en la 4ta fila"},

{id="2A", pos=Vector3(2.02,0.746,-2.06), ticket_correcto="12C", ticket_actual="2A", nombre="Miguel Padilla", desc="Se sentaba con su madre"},
{id="3A", pos=Vector3(1.27,0.746,-2.06), ticket_correcto="12D", ticket_actual="3A", nombre="María Padilla", desc="Le gustaba 12D"},
{id="4A", pos=Vector3(0.542,0.746,-2.06), ticket_correcto="9D", ticket_actual="4A", nombre="Juan Pérez", desc="Siempre en la salida, en los escalones"},
{id="5A", pos=Vector3(-0.91,0.746,-2.06), ticket_correcto="13E", ticket_actual="5A", nombre="Ashlee Urquidi", desc="Hasta la esquina de atrás"},
{id="6A", pos=Vector3(-1.70,0.746,-2.06), ticket_correcto="13A", ticket_actual="6A", nombre="Carlos Mora", desc="Siempre en la ventana del fondo"},
{id="7A", pos=Vector3(-2.53,0.746,-2.06), ticket_correcto="11B", ticket_actual="7A", nombre="Daniel Ríos", desc="Siempre fila 11"},
{id="8A", pos=Vector3(-3.34,0.746,-2.06), ticket_correcto="11A", ticket_actual="8A", nombre="Sofía Ríos", desc="En la ventana, al lado de su hermano"},

{id="2B", pos=Vector3(2.02,0.746,0.924), ticket_correcto="13B", ticket_actual="2B", nombre="Ana Torres", desc="Última fila, detrás de su hermano"},
{id="3B", pos=Vector3(1.27,0.746,0.924), ticket_correcto="12B", ticket_actual="3B", nombre="Luis Torres", desc="En A o en B"},
{id="4B", pos=Vector3(0.542,0.746,0.924), ticket_correcto="8A", ticket_actual="4B", nombre="Ricardo Gómez", desc="Le gustaba el asiento que miraba a la puerta"},
{id="5B", pos=Vector3(-0.91,0.746,0.924), ticket_correcto="1A", ticket_actual="5B", nombre="Eduardo Cedano", desc="Siempre atrás mío"},
{id="6B", pos=Vector3(-1.70,0.746,0.924), ticket_correcto="10D", ticket_actual="6B", nombre="Diego Herrera", desc="Viendo a la ventana, en la fila 10"},

{id="9A", pos=Vector3(-5.72,1.231,-2.2), ticket_correcto="2B", ticket_actual="9A", nombre="Valeria Cruz", desc="Siempre 2B"},
{id="9B", pos=Vector3(-5.72,1.231,-1.36), ticket_correcto="10C", ticket_actual="9B", nombre="Roberto Bolaños", desc="Le gustaba el pasillo"},
{id="9C", pos=Vector3(-5.72,1.231,0.271), ticket_correcto="3B", ticket_actual="9C", nombre="Elena Vargas", desc="Al lado de Valeria Cruz"},
{id="9D", pos=Vector3(-5.72,1.231,1.07), ticket_correcto="11D", ticket_actual="9D", nombre="Samuel García", desc="Siempre la fila 11"},

{id="10A", pos=Vector3(-7.31,1.632,-2.2), ticket_correcto="11C", ticket_actual="10A", nombre="???", desc="???"}, # Entidad
{id="10B", pos=Vector3(-7.31,1.632,-1.36), ticket_correcto="6B", ticket_actual="10B", nombre="Natalia Castillo", desc="Siempre junto a la salida"},
{id="10C", pos=Vector3(-7.31,1.632,0.271), ticket_correcto="9A", ticket_actual="10C", nombre="Héctor Luna", desc="En la ventana, junto a su hermana"},
{id="10D", pos=Vector3(-7.31,1.632,1.07), ticket_correcto="9B", ticket_actual="10D", nombre="Verónica Luna", desc="Siempre en los escalones"},

{id="11A", pos=Vector3(-8.87,1.632,-2.2), ticket_correcto="6A", ticket_actual="11A", nombre="Hanna Aguilar", desc="La pequeña se volteaba para ver la ventana"},
{id="11B", pos=Vector3(-8.87,1.632,-1.36), ticket_correcto="13D", ticket_actual="11B", nombre="Natalia Escobar", desc="Al lado de su amiga Ashlee"},
{id="11C", pos=Vector3(-8.87,1.632,0.271), ticket_correcto="5B", ticket_actual="11C", nombre="Iván Castillo", desc="Junto a su hermana, Natalia"},
{id="11D", pos=Vector3(-8.87,1.632,1.07), ticket_correcto="4B", ticket_actual="11D", nombre=" Tomás Vargas ", desc="Ignoraba a su hermana y su amiga"},

{id="12A", pos=Vector3(-10.4,1.926,-2.2), ticket_correcto="1B", ticket_actual="12A", nombre="Noelia Cázares", desc="Siempre platicaba connmigo"},
{id="12B", pos=Vector3(-10.4,1.926,-1.36), ticket_correcto="10A", ticket_actual="12B", nombre="Javier Campos", desc="Siempre detrás de Hector Luna"},
{id="12C", pos=Vector3(-10.4,1.926,0.271), ticket_correcto="2A", ticket_actual="12C", nombre="Fernando Ruiz", desc="Amigo de Eduardo Cedano"},
{id="12D", pos=Vector3(-10.4,1.926,1.07), ticket_correcto="3A", ticket_actual="12D", nombre="Claudia Ruiz", desc="Junto a su esposo Fernando"},

{id="13A", pos=Vector3(-12.0,1.926,-2.2), ticket_correcto="7A", ticket_actual="13A", nombre="Marco Aguilar", desc="Al lado de su hija"},
{id="13B", pos=Vector3(-12.0,1.926,-1.36), ticket_correcto="5A", ticket_actual="13B", nombre="Julia Aguilar", desc="Al lado de su hija, en los asientos de 4"},
{id="13C", pos=Vector3(-12.0,1.926,-0.60), ticket_correcto="13C", ticket_actual="13C", nombre="Iram Núñez", desc="Con su novia Natalia, hasta la última fila"},
{id="13D", pos=Vector3(-12.0,1.926,0.271), ticket_correcto="9C", ticket_actual="13D", nombre="Paula Vega", desc="Había más espacio en ese lugar"},
{id="13E", pos=Vector3(-12.0,1.926,1.07), ticket_correcto="12A", ticket_actual="13E", nombre="Andrea Solís", desc="Ya sea 11 o 12 A"}
]

var filas_validas = {
	"A": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
	"B": [1, 2, 3, 4, 5, 6, 9, 10, 11, 12, 13],
	"C": [9, 10, 11, 12, 13],
	"D": [9, 10, 11, 12, 13],
	"E": [13]
}

var ticket_en_mano = null
var tickets_instanciados = {}

func _ready() -> void:
	add_to_group("asientos_manager")
	for datos in datos_asientos:
		instanciar_ticket(datos)
	asiento_vacio_nodo = asiento_vacio_escena.instantiate()
	add_child(asiento_vacio_nodo)
	asiento_vacio_nodo.manager = self
	asiento_vacio_nodo.visible = false

func instanciar_ticket(datos: Dictionary) -> void:
	var ticket = ticket_escena.instantiate()
	add_child(ticket)
	ticket.global_position = datos.pos
	ticket.asiento = datos.id
	ticket.nombre = datos.nombre
	ticket.desc = datos.desc
	ticket.manager = self
	ticket.inicializar(datos.nombre,datos.desc)
	ticket.visible = true
	tickets_instanciados[datos.id] = ticket

func buscar_asiento_de_ticket(ticket_id: String) -> String:
	for datos in datos_asientos:
		print(datos.id, " → ticket_actual: ", datos.ticket_actual)
		if datos.ticket_actual == ticket_id:
			return datos.id
	return ""

func recoger_ticket(asiento_id: String) -> void:
	print("RECOGER: ", asiento_id)
	if ticket_en_mano != null:
		return
	ticket_en_mano = asiento_id
	tickets_instanciados[asiento_id].visible = false
	actualizar_ticket_en_asiento(asiento_id, "")
	
	asiento_vacio_nodo = asiento_vacio_escena.instantiate()
	add_child(asiento_vacio_nodo)
	asiento_vacio_nodo.global_position = tickets_instanciados[asiento_id].global_position
	asiento_vacio_nodo.asiento_id = asiento_id
	asiento_vacio_nodo.manager = self
	
	var player = get_tree().get_first_node_in_group("Player")
	player.mostrar_ticket_en_mano(tickets_instanciados[asiento_id])
	
	if entidad.visible:
		mover_entidad(asiento_id)

func colocar_ticket(asiento_destino: String) -> void:
	if ticket_en_mano == null:
		return
	print("intentando colocar en: ", asiento_destino)
	print("asiento_vacio_nodo.asiento_id: ", asiento_vacio_nodo.asiento_id if asiento_vacio_nodo else "null")
	if asiento_vacio_nodo != null and asiento_destino == asiento_vacio_nodo.asiento_id:
		depositar_ticket(asiento_destino)
		return
	var ticket_que_llevo = ticket_en_mano
	var datos_destino = datos_asientos.filter(func(d): return d.id == asiento_destino)[0]
	var ticket_en_destino = datos_destino.ticket_actual
	print("asiento destino: ", asiento_destino)
	print("ticket_actual en ese asiento: ", datos_destino.ticket_actual)
	print("asiento_vacio id: ", asiento_vacio_nodo.asiento_id if asiento_vacio_nodo else "null")
	if ticket_en_destino == "" or ticket_en_destino not in tickets_instanciados:
		return
	
	var player = get_tree().get_first_node_in_group("Player")
	player.soltar_ticket_en_mano()
	
	tickets_instanciados[ticket_que_llevo].global_position = datos_destino.pos
	tickets_instanciados[ticket_que_llevo].visible = true
	actualizar_ticket_en_asiento(asiento_destino, ticket_que_llevo)

	tickets_instanciados[ticket_en_destino].visible = false
	actualizar_ticket_en_asiento(asiento_vacio_nodo.asiento_id, ticket_en_destino)
	ticket_en_mano = ticket_en_destino
	player.mostrar_ticket_en_mano(tickets_instanciados[ticket_en_destino])
	verificar_correctos()

func depositar_ticket(asiento_destino: String) -> void:
	if ticket_en_mano == null:
		return
	
	print("depositando: ", ticket_en_mano, " en: ", asiento_destino)
	
	var player = get_tree().get_first_node_in_group("Player")
	var ticket_que_llevo = ticket_en_mano
	
	player.soltar_ticket_en_mano()
	print("posicion destino: ", datos_asientos.filter(func(d): return d.id == asiento_destino)[0].pos)
	print("ticket instanciado existe: ", ticket_que_llevo in tickets_instanciados)
	tickets_instanciados[ticket_que_llevo].global_position = asiento_vacio_nodo.global_position
	tickets_instanciados[ticket_que_llevo].visible = true
	actualizar_ticket_en_asiento(asiento_vacio_nodo.asiento_id, ticket_que_llevo)
	ticket_en_mano = null
	
	if asiento_vacio_nodo != null:
		asiento_vacio_nodo.queue_free()
		asiento_vacio_nodo = null
	
	verificar_correctos()

func actualizar_ticket_en_asiento(asiento_id: String, nuevo_ticket: String) -> void:
	for datos in datos_asientos:
		if datos.id == asiento_id:
			datos.ticket_actual = nuevo_ticket
			return

func verificar_correctos() -> void:
	for datos in datos_asientos:
		if datos.ticket_actual != datos.ticket_correcto:
			return
	todos_correctos.emit()

func mover_entidad(ticket_id: String) -> void:
	var letra = ticket_id[0]
	var pasos = int(ticket_id.substr(1))
	var col_actual = entidad.asiento_actual[0]
	var fila_actual = int(entidad.asiento_actual.substr(1))
	var cols = ["A", "B", "C", "D", "E"]
	var col_index = cols.find(col_actual)
	
	match letra:
		"A":  # a la izquierda
			col_index = clamp(col_index - pasos, 0, cols.size()-1)
			var nueva_col = cols[col_index]
			fila_actual = fila_mas_cercana(nueva_col, fila_actual)
		"D":  # a la derecha
			col_index = clamp(col_index + pasos, 0, cols.size()-1)
			var nueva_col = cols[col_index]
			fila_actual = fila_mas_cercana(nueva_col, fila_actual)
		"B":  # para atrás
			var filas = filas_validas[col_actual]
			var idx = filas.find(fila_actual)
			idx = clamp(idx + pasos, 0, filas.size()-1)
			fila_actual = filas[idx]
		"C":  # y al frente
			var filas = filas_validas[col_actual]
			var idx = filas.find(fila_actual)
			idx = clamp(idx - pasos, 0, filas.size()-1)
			fila_actual = filas[idx]
	
	var nuevo_asiento = cols[col_index] + str(fila_actual)
	
	for datos in datos_asientos:
		if datos.id == nuevo_asiento:
			entidad.mover_a(Vector3(datos.pos[0], datos.pos[1], datos.pos[2]),nuevo_asiento)
			verificar_entidad()
			return

func verificar_entidad() -> void:
	if entidad.asiento_actual == "10A":
		entidad_colocada.emit()

func fila_mas_cercana(columna: String, fila_ref: int) -> int:
	var filas = filas_validas[columna]
	var mas_cercana = filas[0]
	var menor_diff = abs(filas[0] - fila_ref)
	for f in filas:
		var diff = abs(f - fila_ref)
		if diff < menor_diff:
			menor_diff = diff
			mas_cercana = f
	return mas_cercana
