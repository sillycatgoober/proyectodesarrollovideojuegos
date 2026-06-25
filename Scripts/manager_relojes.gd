extends Node

@export var reloj_1: Node3D
@export var reloj_2: Node3D
@export var reloj_3: Node3D
@export var puerta_biblioteca_1: Node3D 
@export var puerta_biblioteca_2: Node3D 

var resuelto := false

func _ready() -> void:
	if not reloj_1 or not reloj_2 or not reloj_3:
		printerr("ERROR CRÍTICO: ¡Falta arrastrar uno o más relojes al Inspector del Manager!")
		return

	reloj_1.reloj_confirmado.connect(verificar_puzzle)
	reloj_2.reloj_confirmado.connect(verificar_puzzle)
	reloj_3.reloj_confirmado.connect(verificar_puzzle)
	print("Manager: Los 3 relojes están conectados y siendo vigilados.")

func verificar_puzzle() -> void:
	if resuelto:
		return
	
	if reloj_1.hora == reloj_1.hora_correcta and  reloj_2.hora == reloj_2.hora_correcta and  reloj_3.hora == reloj_3.hora_correcta:
		
		resuelto = true
		completar_puzzle()

func completar_puzzle() -> void:
	if puerta_biblioteca_1:
		if "bloqueada" in puerta_biblioteca_1:
			puerta_biblioteca_1.bloqueada = false
		if puerta_biblioteca_1.has_method("abrir"):
			puerta_biblioteca_1.abrir()
		elif puerta_biblioteca_1.has_method("interact"):
			puerta_biblioteca_1.interact() 
			
	if puerta_biblioteca_2:
		if "bloqueada" in puerta_biblioteca_2:
			puerta_biblioteca_2.bloqueada = false
		if puerta_biblioteca_2.has_method("abrir"):
			puerta_biblioteca_2.abrir()
		elif puerta_biblioteca_2.has_method("interact"):
			puerta_biblioteca_2.interact()
