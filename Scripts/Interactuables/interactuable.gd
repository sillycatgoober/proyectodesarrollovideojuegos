extends Node3D
class_name Interactuable

@export var usa_focus := false
@export var puede_interactuar:=true
@export var focus_offset := Vector3(0, 1.5, -0.5)
@onready var camara:Camera3D
@onready var audio:AudioStreamPlayer
var jugador_cerca := false
var en_interaccion := false

func _ready() -> void:
	if $AudioStreamPlayer!=null:
		audio = $AudioStreamPlayer
	if usa_focus:
		camara = $Camera3D

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

#Revisar si jugador esta en area (esto puede ser inutil)
#func puede_interactuar(player):
	#return jugador_cerca
#
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.name == "Player":
		#jugador_cerca = true
#
#func _on_area_3d_body_exited(body: Node3D) -> void:
	#if body.name == "Player":
		#jugador_cerca = false
