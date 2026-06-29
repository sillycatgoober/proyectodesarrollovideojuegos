extends Area3D

@onready var contenedor_puntos: Node3D = $"../PuntosDestino"

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var puntos = contenedor_puntos.get_children()	
		var punto_elegido = puntos.pick_random()
		
		body.global_position = punto_elegido.global_position
