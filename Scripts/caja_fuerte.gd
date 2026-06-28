extends Interactuable

@export var manager: Node
@export var combinacion_correcta: Array[int] = [1, 4, 7, 3]

# Parámetros para controlar el movimiento del encendedor
@export var distancia_salida_x: float = 1.0
@export var tiempo_salida: float = 0.8

@onready var caja_botones: CanvasLayer = $CajaBotones
@onready var combinacion_label: Label = $CajaBotones/CombinacionLabel
# Referencia automática al nodo según la estructura de tu árbol
@export var encendedor_recogible: Node3D

var combinacion_ingresada: String = ""
var abierta := false

func _ready() -> void:
	if usa_focus:
		camara = $Camera3D
	caja_botones.hide()
	
	# Bloqueamos la interacción del encendedor al inicio para que no se altere antes de abrirse
	if encendedor_recogible != null:
		encendedor_recogible.puede_interactuar = false

	$CajaBotones/Button0.pressed.connect(presionar_boton.bind(0))
	$CajaBotones/Button1.pressed.connect(presionar_boton.bind(1))
	$CajaBotones/Button2.pressed.connect(presionar_boton.bind(2))
	$CajaBotones/Button3.pressed.connect(presionar_boton.bind(3))
	$CajaBotones/Button4.pressed.connect(presionar_boton.bind(4))
	$CajaBotones/Button5.pressed.connect(presionar_boton.bind(5))
	$CajaBotones/Button6.pressed.connect(presionar_boton.bind(6))
	$CajaBotones/Button7.pressed.connect(presionar_boton.bind(7))
	$CajaBotones/Button8.pressed.connect(presionar_boton.bind(8))
	$CajaBotones/Button9.pressed.connect(presionar_boton.bind(9))

func interact() -> void:
	if abierta or not puede_interactuar:
		return
	en_interaccion = !en_interaccion
	var player = get_player()
	if player == null:
		return
	if en_interaccion:
		player.puede_moverse = false
		camara.current = true
		caja_botones.show()
		combinacion_label.text = ""
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		player.puede_moverse = true
		player.set_camara_activa(true)
		caja_botones.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func presionar_boton(numero: int) -> void:
	if abierta or not en_interaccion:
		return
	if combinacion_ingresada.length() >= 4:
		return
	combinacion_ingresada += str(numero)
	combinacion_label.text = combinacion_ingresada
	if combinacion_ingresada.length() == 4:
		verificar_combinacion()

func verificar_combinacion() -> void:
	var ingresada = []
	for c in combinacion_ingresada:
		ingresada.append(int(c))
	if ingresada == combinacion_correcta:
		abrir()
		puede_interactuar = false
	else:
		combinacion_label.text = "X"
		combinacion_ingresada = ""
		await get_tree().create_timer(1.0).timeout
		combinacion_label.text = ""

func abrir() -> void:
	abierta = true
	var player = get_player()
	if player:
		player.puede_moverse = true
		player.set_camara_activa(true)
		# Se remueve 'player.tiene_encendedor = true' para que el jugador
		# use la lógica de tu nodo 'InteractuableRecogible' al interactuar con él directamente.
		
	en_interaccion = false
	combinacion_label.text = "OK"
	caja_botones.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Desencadena el desplazamiento del objeto
	animar_salida_encendedor()
	
	if manager:
		manager.on_caja_abierta()

func animar_salida_encendedor() -> void:
	if encendedor_recogible != null:
		var tween = get_tree().create_tween()
		
		# Calculamos el desplazamiento local en X
		var posicion_final = encendedor_recogible.position
		posicion_final.x += distancia_salida_x
		
		# Suavizado de inicio a fin con TRANS_SINE y EASE_OUT
		tween.tween_property(encendedor_recogible, "position", posicion_final, tiempo_salida)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
			
		# Una vez el encendedor termina de salir por completo, se vuelve interactuable para recogerse
		tween.tween_callback(func(): encendedor_recogible.puede_interactuar = true)

func grab():
	pass
