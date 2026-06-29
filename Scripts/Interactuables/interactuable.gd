extends Node3D
class_name Interactuable

@export var usa_focus := false
@export var puede_interactuar :=true
@export var focus_offset := Vector3(0, 1.5, -0.5)
@export var tiene_scroll := false
@export var texto_scroll := ""
@export var texto_esc := "Regresar"
@export var tiene_e:=true
@onready var camara: Camera3D
@onready var audio: AudioStreamPlayer
var jugador_cerca := false
var en_interaccion := false
var texto_e := ""
var texto_f := ""

func _ready() -> void:
	if $AudioStreamPlayer!=null:
		audio = $AudioStreamPlayer
	if usa_focus:
		camara = $Camera3D
	en_interaccion = false

func interact():
	en_interaccion = !en_interaccion
	var player = get_player()
	if player == null:
		return
	if not usa_focus:
		return
	
	if en_interaccion:
		player.puede_moverse = false
		camara.current = true
	else:
		player.puede_moverse = true
		player.set_camara_activa(true)

func desbloquear():
	puede_interactuar = true

func get_player():
	return get_tree().get_first_node_in_group("Player")

func set_player_cam():
	en_interaccion = false
	get_player().puede_moverse = true
	get_player().set_camara_activa(true)
