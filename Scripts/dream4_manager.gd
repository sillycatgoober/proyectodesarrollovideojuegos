extends Node3D

@export var puerta_cuarto_a: Node
@export var puerta_cuarto_b: Node
@export var puerta_elevador: Node
@export var puerta_elevador2: Node
@export var audio:AudioStreamPlayer
@export var encendedor: Node3D
@export var area:Area3D
@onready var cubiculo = $Cubiculo
@onready var anim_ojos = $OjosAnim

var cubiculo_encontrado := false
var caja_abierta := false
var encendedor_usado := false
var area_activada := false
var tipo_quemado:String

signal cubiculo_activado
signal caja_fuerte_abierta
signal sueño_completado

func _ready() -> void:
	GameManager.Fase.SUENO
	GameManager.guardar()
	UI.leave_menu.visible = false
	audio.play()
	if puerta_cuarto_a:
		puerta_cuarto_a.bloqueada = true
	if puerta_cuarto_b:
		puerta_cuarto_b.bloqueada = true
	if puerta_elevador:
		puerta_elevador.bloqueada = true

	anim_ojos.visible = true
	anim_ojos.play("open")
	await anim_ojos.animation_finished
	anim_ojos.visible = false
	UI.set_hints("Dice que comienza trabajando en su cubículo, pero ¿cuál es?")

func on_caja_abierta() -> void:
	if caja_abierta:
		return
	caja_abierta = true
	encendedor.puede_interactuar = true
	emit_signal("caja_fuerte_abierta")

func on_archivo_quemado(tipo: String) -> void:
	if encendedor_usado:
		return
	encendedor_usado = true
	tipo_quemado = tipo
	if tipo == "trabajo":
		audio.stop()
		UI.set_hints("Mucho trabajo por hoy. Parece que cambió algo.")
	elif tipo == "familia":
		UI.set_hints("Cuanto trabajo, espero poder salir de aquí.")
	await get_tree().create_timer(2.0).timeout
	if puerta_elevador and puerta_elevador2:
		puerta_elevador.desbloquear()
		puerta_elevador2.desbloquear()
		puerta_elevador.abrir_puerta_elevador()
		puerta_elevador2.abrir_puerta_elevador()
		area.habilitada = false
	emit_signal("sueño_completado")

func _on_salida_body_entered(body: Node3D) -> void:
	if not body.name == "Player":
		return
	if puerta_elevador.bloqueada:
		return
	GameManager.dreams["3"]["done"] = true
	GameManager.fase_actual = GameManager.Fase.DIAGNOSTICO
	GameManager.guardar()

	anim_ojos.visible = true
	anim_ojos.play("close")
	await anim_ojos.animation_finished
		
	get_tree().change_scene_to_file("res://Scenes/office.tscn")
