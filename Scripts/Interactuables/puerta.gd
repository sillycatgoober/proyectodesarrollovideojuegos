extends Interactuable

var abierta: bool = false
@export var bloqueada: bool = false
@export var modelo_puerta: PackedScene
@export var angulo_apertura := 90.0
@export var sonido_abrir : AudioStream
@export var sonido_bloqueada : AudioStream
@export var is_elevador:=false
@export var direccion: float = 1.0
@export var distancia: float = 1.5
@onready var model = $Model
var posicion_original: Vector3
var rotacion_inicial: float

func _ready() -> void:
	audio = $AudioStreamPlayer
	posicion_original = position
	rotacion_inicial = rotation_degrees.y
	if modelo_puerta:
		var instancia = modelo_puerta.instantiate()
		model.add_child(instancia)

func interact():
	if bloqueada:
		UI.set_hints("Mmm... tengo que ver como desbloquearla.")
		audio.stream = sonido_bloqueada
		audio.play()
		return
	audio.stream = sonido_abrir
	if not abierta:
		if not is_elevador:
			abrir_puerta()
		else:
			abrir_puerta_elevador()
	else:
		if not is_elevador:
			cerrar_puerta()
		else:
			cerrar_puerta_elevador()
	audio.play()

func abrir_puerta():
	abierta = true
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees:y", rotacion_inicial + angulo_apertura, 0.8)

func abrir_puerta_elevador():
	if abierta:
		return
	abierta = true
	create_tween().tween_property(self, "position:z", posicion_original.z + (distancia * direccion), 0.8)

func cerrar_puerta():
	abierta = false
	create_tween().tween_property(self, "rotation_degrees:y", rotacion_inicial, 0.8)

func cerrar_puerta_elevador():
	if not abierta:
		return
	abierta = false
	create_tween().tween_property(self, "position:z", posicion_original.z, 0.8)

func desbloquear():
	bloqueada = false

func desbloquear_salida():
	bloqueada = false
	abrir_puerta()

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		jugador_cerca = true

func _on_area_3d_body_exited(body):
	if body.name == "Player":
		jugador_cerca = false
