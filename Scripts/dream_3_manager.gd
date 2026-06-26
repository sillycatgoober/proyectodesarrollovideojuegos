extends Node3D
@export var asientos_manager: Node
@export var entidad: Node
@export var tablero: Node
@export var puerta_sal1: Node
@export var puerta_sal2: Node
@export var puerta_sal3: Node

func _ready() -> void:
	asientos_manager.todos_correctos.connect(_on_tickets_correctos)
	asientos_manager.entidad = entidad
	entidad.entidad_colocada.connect(_on_entidad_colocada)
	#tablero.ruta_correcta.connect(_on_ruta_correcta)

func _on_tickets_correctos() -> void:
	entidad.aparecer()

func _on_entidad_colocada() -> void:
	tablero.desbloquear()

func _on_ruta_correcta() -> void:
	puerta_sal1.desbloquear_salida()
	puerta_sal2.desbloquear_salida()
	puerta_sal3.desbloquear_salida()
	GameManager.dreams[3].done = true
