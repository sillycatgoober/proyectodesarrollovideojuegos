extends Node

var items = []

func add_item(id):
	if not id in items:
		items.append(id)
		print("added")

func remove_item(id):
	if not id in items:
		return
	items.erase(id)
	print("erased")

func has_item(id):
	return id in items
