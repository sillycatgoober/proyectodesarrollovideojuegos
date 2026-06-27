extends InteractuableExport
@export var item_id : String
@export var nombre : String
@export_multiline var descripcion : String
@export var imagen : Texture2D

func grab():
	print("grabbed")
	InventoryManager.add_item(item_id)
	set_player_cam()
	queue_free()
