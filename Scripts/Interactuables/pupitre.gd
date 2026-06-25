extends Interactuable
@onready var carta:Node3D = $carta
signal carta_colocada

func _ready() -> void:
	carta.visible = false

func interact():
	InventoryManager.remove_item("carta")
	puede_interactuar = false
	carta.visible = true
	carta_colocada.emit()
