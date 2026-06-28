extends Area3D

@export var dream_manager: Node3D
@export var modelo_valvula: PackedScene

var jugador_cerca: bool = false
var girada: bool = false

@onready var model = $Model

func _ready() -> void:
	if modelo_valvula:
		var instancia = modelo_valvula.instantiate()
		model.add_child(instancia)
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if jugador_cerca and event.is_action_pressed("interact") and not girada:
		interact()
		get_viewport().set_input_as_handled()

func interact() -> void:
	girada = true
	print("Válvula girada")
	
	if dream_manager and dream_manager.has_method("registrar_valvula"):
		dream_manager.registrar_valvula()
	
	set_process_unhandled_input(false)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = true
		set_process_unhandled_input(true)
		print("Jugador cerca de la válvula. Presiona E para girar.")

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = false
		set_process_unhandled_input(false)
		print("Jugador se alejó de la válvula.")
