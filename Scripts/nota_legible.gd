extends Interactuable

@export_multiline var texto_nota: String = "ESTUDIANTE FALLECE TRAS COLAPSO...\n\nUn trágico incidente ocurrió hoy durante la clase..."
var leyendo: bool = false

func interact() -> void:
	leyendo = !leyendo
	var player = get_player() 
	
	if leyendo:
		player.puede_moverse = false
		UI.mostrar_texto(texto_nota) 
	else:
		player.puede_moverse = true
		UI.ocultar_texto()

func _input(event: InputEvent) -> void:
	if not leyendo:
		return
		
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		interact()
		get_viewport().set_input_as_handled()
