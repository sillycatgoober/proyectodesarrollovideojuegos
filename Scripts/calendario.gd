extends Interactuable
@export var manager: Node3D 

var puzzle_resuelto: bool = false
var mouse_liberado: bool = false

func _ready() -> void:
	if $AudioStreamPlayer != null:
		audio = $AudioStreamPlayer
	camara = $Camera3D
	
	set_process_unhandled_input(false)

func _process(delta: float) -> void:
	if en_interaccion and not mouse_liberado:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_liberado = true
		print("mouse liberado")
	elif not en_interaccion and mouse_liberado:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_liberado = false
		print("mouse oculto")

func _unhandled_input(event: InputEvent) -> void:
	pass

func resolver_puzzle() -> void:
	puzzle_resuelto = true
	print("dia 31 presionado correctamente con click")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_liberado = false
	
	if audio:
		audio.play() 
		
	if manager:
		if manager.has_method("calendario_resuelto"):
			print("avisando al manager que se resolvio el calendario")
			manager.calendario_resuelto()
		else:
			print("error el manager esta asignado pero no tiene la funcion calendario_resuelto")
	else:
		print("falta asignar el manager en el inspector del calendario")

func _on_boton_31_pressed() -> void:
	if en_interaccion and not puzzle_resuelto:
		print("se hizo click con el mouse en el boton 31")
		resolver_puzzle()
