extends Node3D

@export var puerta_cuarto_a: Node
@export var puerta_cuarto_b: Node
@export var puerta_elevador: Node

var cubiculo_encontrado := false
var caja_abierta := false
var encendedor_usado := false

signal cubiculo_activado
signal caja_fuerte_abierta
signal sueño_completado

func _ready() -> void:
	if puerta_cuarto_a:
		puerta_cuarto_a.puede_interactuar = false
	if puerta_cuarto_b:
		puerta_cuarto_b.puede_interactuar = false
	if puerta_elevador:
		puerta_elevador.puede_interactuar = false
		
func on_cubiculo_activado() -> void:
	if cubiculo_encontrado:
		return
	cubiculo_encontrado = true
	print("Cubículo 4471 encontrado — desbloqueando cuartos A y B")
	
	if puerta_cuarto_a:
		puerta_cuarto_a.desbloquear()
	if puerta_cuarto_b:
		puerta_cuarto_b.desbloquear()
	
	emit_signal("cubiculo_activado")
	UI.mostrar_texto("Se escucha un clic lejano. Algo se desbloqueó.")

func on_caja_abierta() -> void:
	if caja_abierta:
		return
	caja_abierta = true
	print("Caja fuerte abierta — encendedor disponible")
	emit_signal("caja_fuerte_abierta")

func on_archivo_quemado(tipo: String) -> void:
	if encendedor_usado:
		return
	encendedor_usado = true
	
	if tipo == "trabajo":
		print("Quemó el archivo de trabajo — TV se apaga")
		UI.mostrar_texto("La TV se apaga. Silencio.")
	elif tipo == "familia":
		print("Quemó el archivo de familia — TV muestra hija")
		UI.mostrar_texto("La TV muestra una imagen. Una niña sonríe.")
	
	await get_tree().create_timer(2.0).timeout
	
	if puerta_elevador:
		puerta_elevador.desbloquear()
		puerta_elevador.abrir_puerta()
	
	emit_signal("sueño_completado")
	GameManager.dreams[4] = {"done": true}

func _on_salida_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		print("Saliendo del sueño 4")
		TransitionManager.play_transition("res://Scenes/office.tscn")
