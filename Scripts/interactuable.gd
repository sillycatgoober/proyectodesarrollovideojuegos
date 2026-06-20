extends Node3D
class_name Interactuable

@export var usa_focus := false
@export var focus_offset := Vector3(0, 1.5, -0.5)
var jugador_cerca := false

func puede_interactuar(player):
	return jugador_cerca and volteando(player)

func volteando(player):
	var to_obj = (global_position - player.global_position).normalized()
	var forward = -player.camara.global_transform.basis.z
	return forward.dot(to_obj) > 0.6

func interact():
	pass

func get_player():
	return get_tree().get_first_node_in_group("Player")
