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
	
	puerta_sotano.desbloquear()
	
func calendario_resuelto() -> void:
	puerta_salida.desbloquear()


func _on_salida_body_entered(body: Node3D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/animacion_transicion.tscn")
