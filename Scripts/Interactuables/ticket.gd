extends Interactuable
@export var nombre:String
@export var desc:String
@export var asiento:String
@onready var nombreLabel:Label3D = $ticket/Nombre
@onready var descLabel:Label3D = $ticket/Desc

func _ready() -> void:
	nombreLabel.text = nombre
	descLabel.text = desc

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

func _input(event: InputEvent) -> void:
	if not en_interaccion:
		return

func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = false
