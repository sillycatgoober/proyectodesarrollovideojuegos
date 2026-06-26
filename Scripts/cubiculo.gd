extends Interactuable

@export var manager: Node

func interact() -> void:
	if not puede_interactuar:
		return
	puede_interactuar = false
	
	if manager:
		manager.on_cubiculo_activado()
