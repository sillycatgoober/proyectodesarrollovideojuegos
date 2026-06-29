extends Node3D

@export var nivel_agua: Node3D 
@export var calendario: Node3D 
@export var puerta_sotano: Node3D
@export var puerta_salida: Node3D
@onready var anim_ojos = $AnimOjos

var valvulas_activas: int = 0
const TOTAL_VALVULAS: int = 3
var nivel_agua_valor: int = 5
const ALTURA_POR_NIVEL := 0.2
var ultima_valvula: int = -1
var posicion_inicial: Vector3

var valvulas = {
	1: -3,
	2: -1,
	3: 2
}
func _ready() -> void:
	GameManager.Fase.SUENO
	GameManager.guardar()
	UI.leave_menu.visible = false
	posicion_inicial = nivel_agua.position
	anim_ojos.visible = true
	anim_ojos.play("open")
	await anim_ojos.animation_finished
	anim_ojos.visible = false

func registrar_valvula(id:int):
	if id == ultima_valvula:
		UI.set_hints("Ahora no bajó el agua...")
		return
	ultima_valvula = id
	nivel_agua_valor += valvulas[id]
	actualizar_agua()
	comprobar_agua()

func comprobar_agua():
	if nivel_agua_valor <= 0:
		puerta_sotano.desbloquear()
		UI.set_hints("Parece que desapareció el agua, ¿cambió algo?")
		nivel_agua.hide()

func actualizar_agua():
	var destino = posicion_inicial.y - (5 - nivel_agua_valor) * ALTURA_POR_NIVEL
	var tween = create_tween()
	tween.tween_property(nivel_agua, "position:y", destino, 0.5)

func calendario_resuelto() -> void:
	puerta_salida.desbloquear()

func _on_salida_body_entered(body: Node3D) -> void:
	if not body.name == "Player":
		return
	if puerta_salida.bloqueada:
		return
	GameManager.dreams["2"]["done"] = true
	GameManager.fase_actual = GameManager.Fase.DIAGNOSTICO
	GameManager.guardar()
	
	anim_ojos.visible = true
	anim_ojos.play("close")
	await anim_ojos.animation_finished
	
	get_tree().change_scene_to_file("res://Scenes/office.tscn")
