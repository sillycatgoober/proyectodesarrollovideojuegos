extends Node3D
signal entidad_colocada
var asiento_actual: String = "10A"

func _ready() -> void:
	visible = false

func aparecer() -> void:
	visible = true

func mover_a(posicion: Vector3, nuevo_asiento: String) -> void:
	asiento_actual = nuevo_asiento
	global_position = posicion
