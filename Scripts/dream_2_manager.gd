extends Node3D

@export var nivel_agua: Node3D 
@export var calendario: Node3D 

var valvulas_activas: int = 0
const TOTAL_VALVULAS: int = 3

func _ready() -> void:
	pass

func registrar_valvula():
	valvulas_activas += 1
	print("Válvulas activas: ", valvulas_activas, " / ", TOTAL_VALVULAS)
	
	if valvulas_activas >= TOTAL_VALVULAS:
		bajar_nivel_agua()

func bajar_nivel_agua():
	print("El nivel del agua ha bajado para permitir el acceso al sótano.")

func verificar_fecha_calendario(dia: int, mes: int):
	pass
