extends Interactuable

func interact():
	if not InventoryManager.has_item(0):
		print("No tienes la carta")
		return
	print("correcto")
