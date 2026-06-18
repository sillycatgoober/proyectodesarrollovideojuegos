extends Node3D

var jugador_cerca: bool = false
var puerta_abierta: bool = false

@onready var modelo_puerta = $Object_8_001

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interact"):
		if not puerta_abierta:
			abrir_puerta()
		else:
			cerrar_puerta()

func abrir_puerta():
	puerta_abierta = true
	var tween = create_tween()
	tween.tween_property(modelo_puerta, "rotation:y", deg_to_rad(90), 0.8)

func cerrar_puerta():
	puerta_abierta = false
	var tween = create_tween()
	tween.tween_property(modelo_puerta, "rotation:y", deg_to_rad(0), 0.8)

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		jugador_cerca = true

func _on_area_3d_body_exited(body):
	if body.name == "Player":
		jugador_cerca = false
