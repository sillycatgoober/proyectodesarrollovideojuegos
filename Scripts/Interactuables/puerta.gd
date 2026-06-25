extends Interactuable

var abierta: bool = false
@export var bloqueada: bool = false
@export var modelo_puerta: PackedScene
@export var angulo_apertura := 90.0
@onready var model = $Model


func _ready() -> void:
	if modelo_puerta:
		var instancia = modelo_puerta.instantiate()
		model.add_child(instancia)

func interact():
	if bloqueada:
		print("La puerta está bloqueada")
		return
	if not abierta:
		abrir_puerta()
	else:
		cerrar_puerta()

func abrir_puerta():
	abierta = true
	create_tween().tween_property(self, "rotation:y", deg_to_rad(angulo_apertura), 0.8)

func cerrar_puerta():
	abierta = false
	create_tween().tween_property(self, "rotation:y", deg_to_rad(0), 0.8)

func desbloquear():
	bloqueada = false

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		jugador_cerca = true

func _on_area_3d_body_exited(body):
	if body.name == "Player":
		jugador_cerca = false
