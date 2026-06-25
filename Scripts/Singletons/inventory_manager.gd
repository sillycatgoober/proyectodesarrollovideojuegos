extends Node

signal item_added(item_id)
var items = []

func add_item(id):
	if not id in items:
		items.append(id)
		item_added.emit(id)

func remove_item(id):
	if not id in items:
		return
	items.erase(id)
	print("erased")

func has_item(id):
	return id in items
