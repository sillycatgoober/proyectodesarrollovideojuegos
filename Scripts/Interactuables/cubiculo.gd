extends Interactuable
@export var puerta_cuarto_a:Node3D
@export var puerta_cuarto_b:Node3D
var ya_interactuo :=false

func _ready() -> void:
	texto_e = "Trabajar"
	en_interaccion = false
	
func interact():
	if ya_interactuo:
		return
	ya_interactuo = true
	puede_interactuar = false
	puerta_cuarto_a.desbloquear()
	puerta_cuarto_b.desbloquear()
	UI.set_hints("¿Trabajar en un sueño? No gracias. Pero tal vez cambió algo")
