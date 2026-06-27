extends Area3D

@export var dream_manager: Node3D
@export var modelo_valvula: PackedScene
@onready var model = $Model

func _ready() -> void:
	if modelo_valvula:
		var instancia = modelo_valvula.instantiate()
		model.add_child(instancia)

func interact() -> void:
	print("Válvula girada")
	
	if dream_manager and dream_manager.has_method("registrar_valvula"):
		dream_manager.registrar_valvula()
	
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		pass

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		pass
