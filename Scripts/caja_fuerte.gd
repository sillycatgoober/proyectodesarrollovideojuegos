extends Interactuable

@export var manager: Node
@export var combinacion_correcta: Array[int] = [14, 7, 3, 9]

var combinacion_ingresada: Array[int] = [0, 0, 0, 0]
var abierta := false
var digito_actual := 0

func interact() -> void:
	if abierta or not puede_interactuar:
		return
	
	var player = get_player()
	if player == null:
		return
	
	en_interaccion = !en_interaccion
	
	if en_interaccion:
		player.puede_moverse = false
		if usa_focus:
			camara.current = true
		UI.mostrar_texto("Ingresa la combinación.\nUsa rueda del mouse para cambiar el número.\nE para confirmar dígito.")
	else:
		player.puede_moverse = true
		player.set_camara_activa(true)
		UI.ocultar_texto()

func _input(event: InputEvent) -> void:
	if not en_interaccion:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			combinacion_ingresada[digito_actual] = (combinacion_ingresada[digito_actual] + 1) % 32
			UI.mostrar_texto("Dígito %d: %d\nE para confirmar" % [digito_actual + 1, combinacion_ingresada[digito_actual]])
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			combinacion_ingresada[digito_actual] = (combinacion_ingresada[digito_actual] - 1 + 32) % 32
			UI.mostrar_texto("Dígito %d: %d\nE para confirmar" % [digito_actual + 1, combinacion_ingresada[digito_actual]])
	
	if event.is_action_pressed("interact"):
		confirmar_digito()
		get_viewport().set_input_as_handled()

func confirmar_digito() -> void:
	digito_actual += 1
	
	if digito_actual < combinacion_correcta.size():
		UI.mostrar_texto("Dígito %d: 0\nUsa rueda para cambiar" % [digito_actual + 1])
	else:
		verificar_combinacion()

func verificar_combinacion() -> void:
	if combinacion_ingresada == combinacion_correcta:
		abrir()
	else:
		UI.mostrar_texto("Combinación incorrecta.")
		combinacion_ingresada = [0, 0, 0, 0]
		digito_actual = 0
		await get_tree().create_timer(1.5).timeout
		UI.mostrar_texto("Dígito 1: 0\nUsa rueda para cambiar")

func abrir() -> void:
	abierta = true
	var player = get_player()
	
	if player:
		player.puede_moverse = true
		player.set_camara_activa(true)
		player.tiene_encendedor = true 
		
	en_interaccion = false

	UI.mostrar_texto("¡Caja abierta!\nHas encontrado el encendedor.")

	if manager:
		manager.on_caja_abierta()
		
	await get_tree().create_timer(2.5).timeout
	UI.ocultar_texto()
