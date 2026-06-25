extends Interactuable

@export var hora_correcta := 11
@export var id_reloj := 0
@onready var manecilla:MeshInstance3D = $clock/Clock/Obj_Hand_004/Hora
var hora := 1
signal reloj_confirmado

func _ready() -> void:
	add_to_group("reloj")
	camara = $Camera3D
	hora = 12
	actualizar_manecillas()

func interact():
	en_interaccion = !en_interaccion
	var player = get_player()
	if player == null:
		return
	if en_interaccion:
		player.puede_moverse = false
		camara.current = true
	else:
		player.puede_moverse = true
		player.set_camara_activa(true)
		verificar()

func _input(event: InputEvent) -> void:
	if not en_interaccion:
		return

	
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		interact() 
		get_viewport().set_input_as_handled() 
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			cambiar_hora(1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			cambiar_hora(-1)

func cambiar_hora(valor:int):
	if not en_interaccion:
		return
	hora += valor
	if hora > 12:
		hora = 1
	if hora < 1:
		hora = 12
	print("Hora:", hora)
	actualizar_manecillas()

func actualizar_manecillas():
	var hora_angle = float(hora) * 30.0
	manecilla.rotation.z = deg_to_rad(hora_angle)

func verificar():
	if hora == hora_correcta:
		print("RELOJ CORRECTO")
		reloj_confirmado.emit()
	else:
		print("RELOJ INCORRECTO")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = false
