extends Node3D

@export var modelo_puerta: PackedScene
@export var direccion: float = 1.0
@export var distancia: float = 1.5
@export var bloqueada: bool = true
var puede_interactuar := false
var abierta := false
var posicion_original: Vector3
var usa_focus := false
var en_interaccion := false
var tiene_scroll := false

func _ready() -> void:
	posicion_original = position
	if modelo_puerta:
		var instancia = modelo_puerta.instantiate()
		add_child(instancia)

func abrir_puerta() -> void:
	if abierta:
		return
	abierta = true
	create_tween().tween_property(self, "position:z", posicion_original.z + (distancia * direccion), 0.8)

func desbloquear() -> void:
	bloqueada = false
