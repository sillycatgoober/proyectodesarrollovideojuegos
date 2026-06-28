extends Area3D


var jugador_cerca := false

@export var pista_texto: String = "Pista de fecha: ..."
@export var modelo_foto: PackedScene
@onready var model = $Model

func _ready() -> void:
	if modelo_foto:
		var instancia = modelo_foto.instantiate()
		model.add_child(instancia)

func interact() -> void:

	if not jugador_cerca:
		return
	print(pista_texto)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = false
