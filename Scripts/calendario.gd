extends Interactuable
@export var manager: Node3D 
@onready var botones = $Control
var puzzle_resuelto: bool = false
var mouse_liberado: bool = false
var ya_interactuo: bool = false

func _ready() -> void:
	if $AudioStreamPlayer != null:
		audio = $AudioStreamPlayer
	camara = $Camera3D
	set_process_unhandled_input(false)
	botones.hide()

func _process(delta: float) -> void:
	if en_interaccion and not mouse_liberado:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_liberado = true
	elif not en_interaccion and mouse_liberado:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_liberado = false

func interact():
	if not ya_interactuo:
		UI.set_hints("¿Habrá alguna fecha especial que marcar?")
	en_interaccion = !en_interaccion
	ya_interactuo = true
	var player = get_player()
	if player == null:
		return
	if en_interaccion:
		player.puede_moverse = false
		camara.current = true
		botones.show()
		for boton in botones.get_children():
			boton.visible = true
		$Control/Boton31.disabled = false
	else:
		player.puede_moverse = true
		player.set_camara_activa(true)
		botones.hide()
		for boton in botones.get_children():
			boton.visible = false

func _unhandled_input(event: InputEvent) -> void:
	pass

func resolver_puzzle() -> void:
	puzzle_resuelto = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_liberado = false
	
	if audio:
		audio.play() 
	if manager:
		if manager.has_method("calendario_resuelto"):
			UI.set_hints("Hmm... Faltan 24 días para esa fecha")
			manager.calendario_resuelto()

func _on_boton_31_pressed() -> void:
	if en_interaccion and not puzzle_resuelto:
		resolver_puzzle()
