extends Interactuable

@export var manager: Node
@export_enum("trabajo", "familia") var tipo_archivo: String = "trabajo"

func interact() -> void:
	if not puede_interactuar:
		return
		
	var player = get_player()
	if player == null:
		return
		
	en_interaccion = !en_interaccion
	
	if en_interaccion:
		if player.tiene_encendedor:
			player.puede_moverse = false
			UI.mostrar_texto("¿Quemar expediente de " + tipo_archivo + "?\n[Clic Izquierdo] Quemar  |  [E] Cancelar")
		else:

			en_interaccion = false
			UI.mostrar_texto("Necesito algo para prender esto...")
			await get_tree().create_timer(2.0).timeout
			UI.ocultar_texto()
	else:
		# Presionó E para cancelar
		player.puede_moverse = true
		UI.ocultar_texto()

func _input(event: InputEvent) -> void:
	if not en_interaccion:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		quemar_archivo()
		get_viewport().set_input_as_handled()

func quemar_archivo() -> void:
	en_interaccion = false
	puede_interactuar = false
	
	var player = get_player()
	if player:
		player.puede_moverse = true
		
	UI.mostrar_texto("Quemando expediente...")

	if manager and manager.has_method("on_archivo_quemado"):
		manager.on_archivo_quemado(tipo_archivo)

	queue_free()
