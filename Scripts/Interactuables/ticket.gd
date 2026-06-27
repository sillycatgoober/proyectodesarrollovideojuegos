extends Interactuable
@export var nombre:String
@export var desc:String
@export var asiento:String
@onready var nombreLabel:Label3D = $ticket/Nombre
@onready var descLabel:Label3D = $ticket/Desc

var manager = null

func _ready() -> void:
	add_to_group("ticket")
	if $AudioStreamPlayer!=null:
		audio = $AudioStreamPlayer
	if usa_focus:
		camara = $Camera3D

func inicializar(nombre:String, desc:String):
	nombreLabel.text = nombre
	descLabel.text = desc

func grab():
	if manager == null:
		return
	set_player_cam()
	var asiento_actual = manager.buscar_asiento_de_ticket(asiento)
	if manager.ticket_en_mano == null:
		manager.recoger_ticket(asiento_actual)
	else:
		manager.colocar_ticket(asiento_actual)

func _input(event: InputEvent) -> void:
	if not en_interaccion:
		return

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = false
