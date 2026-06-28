extends Area3D

var jugador_cerca := false
var esta_abierta := false

@export var dream_manager: Node3D
@export var esta_bloqueada: bool = true
@export var angulo_abierta: float = 90.0
@export var velocidad_animacion: float = 0.5

@onready var pivot = $Pivot
@onready var audio_player = $AudioStreamPlayer

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		abrir_o_cerrar_puerta()
		get_viewport().set_input_as_handled()

func abrir_o_cerrar_puerta() -> void:
	if esta_bloqueada:
		print("La puerta está bloqueada. Necesitas resolver un puzle.")
		return
	
	esta_abierta = !esta_abierta
	
	var angulo_objetivo: float
	if esta_abierta:
		angulo_objetivo = deg_to_rad(angulo_abierta)
	else:
		angulo_objetivo = deg_to_rad(0.0)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pivot, "rotation:y", angulo_objetivo, velocidad_animacion)
	
	if audio_player:
		audio_player.play()
		
	print("Estado de la puerta modificado. ¿Abierta?: ", esta_abierta)

func desbloquear_puerta() -> void:
	esta_bloqueada = false
	print("¡La puerta ha sido desbloqueada por el gestor de puzles!")

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = true
		set_process_unhandled_input(true)
		print("Jugador cerca de la puerta. Presiona E.")

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = false
		set_process_unhandled_input(false)
		print("Jugador se alejó de la puerta.")
