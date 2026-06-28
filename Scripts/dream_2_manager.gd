extends Node3D

@export var nivel_agua: Node3D 
@export var calendario: Node3D 
@export var puerta_sotano: Node3D
@export var puerta_salida: Node3D
@onready var anim_ojos = $AnimOjos

var valvulas_activas: int = 0
const TOTAL_VALVULAS: int = 3

func _ready() -> void:
	# FLUJO: Entrar al sueño -> Abrir los ojos
	anim_ojos.visible = true
	anim_ojos.play("open")
	await anim_ojos.animation_finished
	anim_ojos.visible = false

func registrar_valvula():
	valvulas_activas += 1
	if valvulas_activas >= TOTAL_VALVULAS:
		bajar_nivel_agua()

func bajar_nivel_agua():
	if nivel_agua:
		nivel_agua.queue_free()
	puerta_sotano.desbloquear()
	
func calendario_resuelto() -> void:
	puerta_salida.desbloquear()

# FLUJO: Terminar sueño -> Cerrar ojos -> Diagnóstico
func _on_salida_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		GameManager.dreams[2]["done"] = true
		GameManager.fase_actual = GameManager.Fase.DIAGNOSTICO
		GameManager.guardar()
		
		anim_ojos.visible = true
		anim_ojos.play("close")
		await anim_ojos.animation_finished
		
		get_tree().change_scene_to_file("res://Scenes/office.tscn")
