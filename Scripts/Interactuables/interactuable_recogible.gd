extends InteractuableExport
@export var item_id : String
@export var nombre : String
@export_multiline var descripcion : String
@export var mensaje: String

func grab():
	if not mensaje=="":
		UI.set_hints(mensaje)
	InventoryManager.add_item(item_id)
	set_player_cam()
	queue_free()
