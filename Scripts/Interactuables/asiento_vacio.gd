extends Interactuable
var asiento_id: String = ""
var manager = null

func _ready() -> void:
	texto_e = "Colocar"
	add_to_group("interactuable")

func interact():
	if manager == null or manager.ticket_en_mano == null:
		return
	manager.depositar_ticket(asiento_id)

func desbloquear():
	puede_interactuar = true

func get_player():
	return get_tree().get_first_node_in_group("Player")
