extends Node3D

@export var nivel_agua: Node3D 
@export var calendario: Node3D 
@export var puerta_sotano: Node3D
@export var puerta_salida: Node3D

var valvulas_activas: int = 0
const TOTAL_VALVULAS: int = 3

func _ready() -> void:
	pass

func registrar_valvula():
	valvulas_activas += 1
	print("valvulas activas: ", valvulas_activas, " / ", TOTAL_VALVULAS)
	
	if valvulas_activas >= TOTAL_VALVULAS:
		bajar_nivel_agua()

func bajar_nivel_agua():
	print("el nivel del agua ha bajado para permitir el acceso al sotano.")
	if nivel_agua:
		nivel_agua.queue_free()
	
	abrir_puerta_sotano()
	
func calendario_resuelto() -> void:
	print("el manager detecto que el calendario fue resuelto")
	desbloquear_puerta_salida()

func abrir_puerta_sotano() -> void:
	if puerta_sotano and puerta_sotano.has_method("desbloquear_puerta"):
		puerta_sotano.desbloquear_puerta()

func desbloquear_puerta_salida() -> void:
	if puerta_salida and puerta_salida.has_method("desbloquear_puerta"):
		print("manager desbloqueando la puerta de salida")
		puerta_salida.desbloquear_puerta()
