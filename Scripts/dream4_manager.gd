extends Node3D

@export var puerta_cuarto_a: Node
@export var puerta_cuarto_b: Node
@export var puerta_elevador: Node
@export var puerta_door2: Node
@export var puerta_door3: Node
@export var puerta_elevador2: Node
# Exportamos anim_ojos para que lo asignes desde el Inspector y evitar errores de ruta
@export var anim_ojos: Node 

@onready var cubiculo: Area3D = $"../Cubiculo"

var cubiculo_encontrado := false
var caja_abierta := false
var encendedor_usado := false
var area_activada := false

signal cubiculo_activado
signal caja_fuerte_abierta
signal sueño_completado

func _ready() -> void:
	$"../Cubiculo".body_entered.connect(_on_cubiculo_body_entered)
	if puerta_cuarto_a:
		puerta_cuarto_a.bloqueada = true
	if puerta_cuarto_b:
		puerta_cuarto_b.bloqueada = true
	if puerta_elevador:
		puerta_elevador.bloqueada = true

	# FLUJO: Entrar al sueño -> Abrir los ojos
	if anim_ojos:
		anim_ojos.visible = true
		anim_ojos.play("open")
		await anim_ojos.animation_finished
		anim_ojos.visible = false

func _on_cubiculo_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		on_area_activada()

func on_area_activada() -> void:
	if area_activada:
		return
	area_activada = true
	if puerta_door2:
		puerta_door2.desbloquear()
		puerta_door2.abrir_puerta()
	if puerta_door3:
		puerta_door3.desbloquear()
		puerta_door3.abrir_puerta()

func on_cubiculo_activado() -> void:
	if cubiculo_encontrado:
		return
	cubiculo_encontrado = true
	if puerta_cuarto_a:
		puerta_cuarto_a.desbloquear()
	if puerta_cuarto_b:
		puerta_cuarto_b.desbloquear()
	emit_signal("cubiculo_activado")

func on_caja_abierta() -> void:
	if caja_abierta:
		return
	caja_abierta = true
	emit_signal("caja_fuerte_abierta")

func on_archivo_quemado(tipo: String) -> void:
	if encendedor_usado:
		return
	encendedor_usado = true
	if tipo == "trabajo":
		print("Quemó el archivo de trabajo — TV se apaga")
	elif tipo == "familia":
		print("Quemó el archivo de familia — TV muestra hija")
	await get_tree().create_timer(2.0).timeout
	if puerta_elevador:
		puerta_elevador.desbloquear()
		puerta_elevador.abrir_puerta()
		puerta_elevador2.abrir_puerta()
	emit_signal("sueño_completado")

# FLUJO: Terminar sueño -> Cerrar ojos -> Diagnóstico
func _on_salida_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		GameManager.dreams["4"]["done"] = true
		GameManager.fase_actual = GameManager.Fase.DIAGNOSTICO
		GameManager.guardar()
		
		# Eliminamos el TransitionManager e integramos AnimOjos
		if anim_ojos:
			anim_ojos.visible = true
			anim_ojos.play("close")
			await anim_ojos.animation_finished
		
		get_tree().change_scene_to_file("res://Scenes/office.tscn")
