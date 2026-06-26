extends Interactuable
@export var nombre:String
@export var desc:String
@export var asiento:String
@onready var nombreLabel:Label3D = $ticket/Nombre
@onready var descLabel:Label3D = $ticket/Desc

var manager = null

func _ready() -> void:
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
	if manager.ticket_en_mano == null:
		# no lleva nada, recoge este
		manager.recoger_ticket(asiento)
	elif manager.ticket_en_mano == asiento:
		# lleva este mismo, lo devuelve
		manager.ticket_en_mano = null
		visible = true
	else:
		# lleva otro, intercambia
		manager.colocar_ticket(asiento)

func _input(event: InputEvent) -> void:
	if not en_interaccion:
		return

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = false
